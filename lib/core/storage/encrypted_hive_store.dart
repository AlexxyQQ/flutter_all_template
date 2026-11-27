import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../error/app_exception.dart';
import '../generic/data/async_lock.dart';
import '../services/logger/data/app_logger.dart';
import 'key_value_stores.dart';

/// App-private storage for sensitive local records: values are AES-GCM
/// ciphertext in a Hive box, the encryption key lives in platform secure
/// storage.
///
/// Record **keys are stored in plain text** so [keys] can list them without
/// decrypting anything. Use opaque, non-sensitive ids as keys (UUIDs,
/// timestamps), never e-mails or other personal data; put that in the value.
/// A key is bound to its value (authenticated data), so ciphertext copied to
/// another key is rejected.
///
/// If the encryption key is lost (new device restore, cleared keystore) the
/// box can never be read again; it is then deleted and recreated empty (with a
/// logged warning) instead of failing every operation forever.
@lazySingleton
final class EncryptedHiveStore {
  EncryptedHiveStore({
    @Named(keyVaultName) required ISecureStore keyVault,
    @ignoreParam String? directoryPath,
  }) : _keyVault = keyVault,
       _directoryPath = directoryPath;

  static const String keyVaultName = 'hiveKeyVault';
  static const String _keyName = 'encrypted_hive_key_v2';
  static const String _boxName = 'secure_records_v2';
  static const String _formatId = '__format__';
  static const String _formatProof = 'secure_records_v2';
  static const int _keySize = 32;
  static const String _name = 'EncryptedHiveStore';

  final ISecureStore _keyVault;
  final String? _directoryPath;
  final AsyncLock _lock = AsyncLock();
  final AesGcm _cipher = AesGcm.with256bits();
  ({Box<String> box, SecretKey dataKey})? _opened;

  Future<String?> read({required String key}) => _run(
    operation: 'read',
    action: () async {
      final opened = await _open();
      final value = opened.box.get(key);
      if (value == null) {
        return null;
      }
      return _decrypt(value: value, id: key, dataKey: opened.dataKey);
    },
  );

  Future<void> write({required String key, required String value}) => _run(
    operation: 'write',
    action: () async {
      if (key == _formatId) {
        throw ArgumentError.value(key, 'key', 'is reserved');
      }
      final opened = await _open();
      final encrypted = await _encrypt(
        value: value,
        id: key,
        dataKey: opened.dataKey,
      );
      await opened.box.put(key, encrypted);
    },
  );

  Future<void> delete({required String key}) => _run(
    operation: 'delete',
    action: () async {
      final opened = await _open();
      await opened.box.delete(key);
    },
  );

  /// Every stored key. Nothing is decrypted, so this is cheap.
  Future<List<String>> keys() => _run(
    operation: 'list keys',
    action: () async {
      final opened = await _open();
      return [
        for (final key in opened.box.keys.cast<String>())
          if (key != _formatId) key,
      ];
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
        _opened = null;
      }
    },
  );

  Future<({Box<String> box, SecretKey dataKey})> _open() async {
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
    var dataKey = await _readKey();
    if (dataKey == null) {
      await _discardBox(path: path, reason: 'its key is missing or invalid');
      dataKey = await _createKey();
    }
    var box = await _openVerified(path: path, dataKey: dataKey);
    if (box == null) {
      await _discardBox(path: path, reason: 'it cannot be read with its key');
      dataKey.destroy();
      dataKey = await _createKey();
      box = await _openVerified(path: path, dataKey: dataKey);
      if (box == null) {
        dataKey.destroy();
        throw const StorageException(
          debugMessage: 'Secure Hive could not verify a newly created store',
        );
      }
    }
    return _opened = (box: box, dataKey: dataKey);
  }

  /// The stored key, or `null` when there is none or it is malformed.
  Future<SecretKeyData?> _readKey() async {
    final stored = await _keyVault.read(key: _keyName);
    if (stored == null) {
      return null;
    }
    try {
      final bytes = base64Url.decode(stored);
      if (bytes.length == _keySize) {
        return SecretKeyData(bytes, overwriteWhenDestroyed: true);
      }
    } on FormatException {
      // Falls through: an undecodable key is as good as a missing one.
    }
    return null;
  }

  Future<SecretKeyData> _createKey() async {
    final material = SecretKeyData.random(length: _keySize);
    final key = SecretKeyData(
      Uint8List.fromList(material.bytes),
      overwriteWhenDestroyed: true,
    );
    material.destroy();
    try {
      await _keyVault.write(key: _keyName, value: base64UrlEncode(key.bytes));
    } catch (_) {
      key.destroy();
      rethrow;
    }
    return key;
  }

  /// Deletes a box that can no longer be decrypted so a new one can be created.
  Future<void> _discardBox({
    required String path,
    required String reason,
  }) async {
    if (!await Hive.boxExists(_boxName, path: path)) {
      return;
    }
    AppLogger.warning(
      'Secure Hive records were discarded because $reason',
      name: _name,
    );
    await Hive.deleteBoxFromDisk(_boxName, path: path);
  }

  /// Opens the box and checks [dataKey] against a marker record (writing it
  /// into a new box). Returns `null` when the box was written with another key.
  Future<Box<String>?> _openVerified({
    required String path,
    required SecretKey dataKey,
  }) async {
    final box = await Hive.openBox<String>(_boxName, path: path);
    try {
      if (box.isEmpty) {
        await box.put(
          _formatId,
          await _encrypt(value: _formatProof, id: _formatId, dataKey: dataKey),
        );
        return box;
      }
      final marker = box.get(_formatId);
      if (marker != null &&
          await _decrypt(value: marker, id: _formatId, dataKey: dataKey) ==
              _formatProof) {
        return box;
      }
    } on SecretBoxAuthenticationError {
      // Wrong key: reported as `null` below.
    } on FormatException {
      // Corrupt marker: same.
    } catch (_) {
      await box.close();
      rethrow;
    }
    await box.close();
    return null;
  }

  Future<String> _decrypt({
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
    return utf8.decode(decrypted);
  }

  Future<String> _encrypt({
    required String value,
    required String id,
    required SecretKey dataKey,
  }) async {
    final encrypted = await _cipher.encrypt(
      utf8.encode(value),
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
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          debugMessage: 'Secure Hive could not $operation',
          cause: error,
        ),
        stackTrace,
      );
    }
  });
}
