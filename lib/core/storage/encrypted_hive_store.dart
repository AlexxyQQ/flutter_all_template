import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../error/app_exception.dart';
import '../generic/data/async_lock.dart';
import 'key_value_stores.dart';

/// App-private storage for sensitive local records. Hive only sees
/// authenticated ciphertext and keyed digests of logical record keys.
@lazySingleton
final class EncryptedHiveStore {
  EncryptedHiveStore({
    @Named(keyVaultName) required SecureStore keyVault,
    @ignoreParam String? directoryPath,
  }) : _keyVault = keyVault,
       _directoryPath = directoryPath;

  static const String keyVaultName = 'hiveKeyVault';
  static const String _keyName = 'encrypted_hive_key_v1';
  static const String _boxName = 'secure_records_v1';
  static const String _formatId = 'format';
  static const int _keySize = 32;

  final SecureStore _keyVault;
  final String? _directoryPath;
  final AsyncLock _lock = AsyncLock();
  final AesGcm _cipher = AesGcm.with256bits();
  final Hmac _keyDigest = Hmac.sha256();
  ({Box<String> box, SecretKey dataKey, SecretKey lookupKey})? _opened;

  Future<String?> read({required String key}) => _run(
    operation: 'read',
    action: () async {
      final opened = await _open();
      final id = await _recordId(key: key, lookupKey: opened.lookupKey);
      final value = opened.box.get(id);
      if (value == null) {
        return null;
      }
      final record = await _decode(
        value: value,
        id: id,
        dataKey: opened.dataKey,
      );
      return record.value;
    },
  );

  Future<void> write({required String key, required String value}) => _run(
    operation: 'write',
    action: () async {
      final opened = await _open();
      final id = await _recordId(key: key, lookupKey: opened.lookupKey);
      final encrypted = await _encode(
        key: key,
        value: value,
        id: id,
        dataKey: opened.dataKey,
      );
      await opened.box.put(id, encrypted);
    },
  );

  Future<void> delete({required String key}) => _run(
    operation: 'delete',
    action: () async {
      final opened = await _open();
      final id = await _recordId(key: key, lookupKey: opened.lookupKey);
      await opened.box.delete(id);
    },
  );

  Future<List<String>> keys() => _run(
    operation: 'list keys',
    action: () async {
      final opened = await _open();
      final logicalKeys = <String>[];
      for (final id in opened.box.keys.cast<String>()) {
        if (id == _formatId) {
          continue;
        }
        final record = await _decode(
          value: opened.box.get(id)!,
          id: id,
          dataKey: opened.dataKey,
        );
        logicalKeys.add(record.key);
      }
      return logicalKeys;
    },
  );

  @disposeMethod
  Future<void> close() => _run(
    operation: 'close',
    action: () async {
      final opened = _opened;
      if (opened == null) {
        return;
      }
      try {
        await opened.box.close();
      } finally {
        opened.dataKey.destroy();
        opened.lookupKey.destroy();
        _opened = null;
      }
    },
  );

  Future<({Box<String> box, SecretKey dataKey, SecretKey lookupKey})>
  _open() async {
    final opened = _opened;
    if (opened != null) {
      return opened;
    }
    if (kIsWeb) {
      throw const StorageException(
        debugMessage: 'Secure Hive storage requires a native key vault',
      );
    }

    final path =
        _directoryPath ?? (await getApplicationSupportDirectory()).path;
    final storedKey = await _keyVault.read(_keyName);
    final Uint8List bytes;
    if (storedKey == null) {
      if (await Hive.boxExists(_boxName, path: path)) {
        throw const StorageException(
          debugMessage: 'Secure Hive key is missing for an existing store',
        );
      }
      final material = SecretKeyData.random(length: _keySize * 2);
      try {
        await _keyVault.write(_keyName, base64UrlEncode(material.bytes));
        bytes = Uint8List.fromList(material.bytes);
      } finally {
        material.destroy();
      }
    } else {
      bytes = base64Url.decode(storedKey);
      if (bytes.length != _keySize * 2) {
        throw const StorageException(
          debugMessage: 'Secure Hive key has an invalid length',
        );
      }
    }

    final dataKey = SecretKeyData(
      Uint8List.sublistView(bytes, 0, _keySize),
      overwriteWhenDestroyed: true,
    );
    final lookupKey = SecretKeyData(
      Uint8List.sublistView(bytes, _keySize),
      overwriteWhenDestroyed: true,
    );
    Box<String>? box;
    try {
      box = await Hive.openBox<String>(_boxName, path: path);
      await _verifyFormat(box: box, dataKey: dataKey, lookupKey: lookupKey);
      return _opened = (box: box, dataKey: dataKey, lookupKey: lookupKey);
    } catch (_) {
      dataKey.destroy();
      lookupKey.destroy();
      await box?.close();
      rethrow;
    }
  }

  Future<void> _verifyFormat({
    required Box<String> box,
    required SecretKey dataKey,
    required SecretKey lookupKey,
  }) async {
    final proof = await _recordId(key: _boxName, lookupKey: lookupKey);
    if (box.isEmpty) {
      final encrypted = await _encode(
        key: _formatId,
        value: proof,
        id: _formatId,
        dataKey: dataKey,
      );
      await box.put(_formatId, encrypted);
      return;
    }
    final marker = box.get(_formatId);
    if (marker != null) {
      final record = await _decode(
        value: marker,
        id: _formatId,
        dataKey: dataKey,
      );
      if (record.value == proof) {
        return;
      }
    }
    throw const StorageException(
      debugMessage: 'Secure Hive could not verify the store key',
    );
  }

  Future<String> _recordId({
    required String key,
    required SecretKey lookupKey,
  }) async {
    final digest = await _keyDigest.calculateMac(
      utf8.encode(key),
      secretKey: lookupKey,
    );
    return base64UrlEncode(digest.bytes);
  }

  Future<({String key, String value})> _decode({
    required String value,
    required String id,
    required SecretKey dataKey,
  }) async {
    final encrypted = SecretBox.fromConcatenation(
      base64Url.decode(value),
      nonceLength: _cipher.nonceLength,
      macLength: _cipher.macAlgorithm.macLength,
    );
    final decrypted = await _cipher.decrypt(
      encrypted,
      secretKey: dataKey,
      aad: utf8.encode(id),
    );
    final fields = jsonDecode(utf8.decode(decrypted)) as List<dynamic>;
    return (key: fields[0] as String, value: fields[1] as String);
  }

  Future<String> _encode({
    required String key,
    required String value,
    required String id,
    required SecretKey dataKey,
  }) async {
    final encrypted = await _cipher.encrypt(
      utf8.encode(jsonEncode([key, value])),
      secretKey: dataKey,
      aad: utf8.encode(id),
    );
    return base64UrlEncode(encrypted.concatenation());
  }

  Future<T> _run<T>({
    required String operation,
    required Future<T> Function() action,
  }) => _lock.synchronized(() async {
    try {
      return await action();
    } on StorageException {
      rethrow;
    } catch (error) {
      throw StorageException(
        debugMessage: 'Secure Hive could not $operation',
        cause: error.runtimeType,
      );
    }
  });
}
