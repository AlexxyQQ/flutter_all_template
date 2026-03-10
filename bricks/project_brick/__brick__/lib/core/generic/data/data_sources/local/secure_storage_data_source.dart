import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../common/domain/entities/failure.dart';
import '../../../../common/domain/services/logger/logger_service.dart';
import '../../../../common/domain/services/storage/secure_storage_service.dart';

/// A generic data source that stores a List<T> inside a single SecureStorage key.
abstract class ISecureStorageDataSource<T> {
  ISecureStorageDataSource({
    required this.secureStorageService,
    required this.modelKey,
    this.seedAssetPath,
  });

  final SecureStorageService secureStorageService;
  final String? seedAssetPath;
  final String modelKey;

  /// Helper getter to create a consistent log tag
  /// Example output: "SecureStorage:user_preferences"
  String get _logTag => 'SecureStorage:$modelKey';

  // -----------------------------------------------------------------------------
  // Abstract Methods (To be implemented by the concrete class)
  // -----------------------------------------------------------------------------

  /// Convert object to Map.
  Map<String, dynamic> toJson(T object);

  /// Create object from Map.
  T fromJson(Map<String, dynamic> json);

  /// Used for updates.
  T copyWith(T existingItem, T newValue);

  // -----------------------------------------------------------------------------
  // Internal Helpers (Serialization)
  // -----------------------------------------------------------------------------

  String _listToJsonString(List<T> list) {
    final List<Map<String, dynamic>> jsonList = list
        .map((item) => toJson(item))
        .toList();
    return jsonEncode(jsonList);
  }

  List<T> _listFromJsonString(String jsonStr) {
    final List<dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  /// The "Magic" method that handles the Read -> Modify -> Write pipeline.
  Future<Either<Failure, ReturnType>> _editList<ReturnType>({
    required Future<Either<Failure, ReturnType>> Function(List<T> list) action,
  }) async {
    try {
      // LOG: Start Transaction
      AppLogger.debug('🔄 Starting write transaction...', name: _logTag);

      // 1. Read existing
      final readResult = await getAll();

      return readResult.fold(
        (failure) {
          AppLogger.error(
            '❌ Transaction aborted: Failed to read initial data.',
            name: _logTag,
          );
          return Left(failure);
        },
        (currentList) async {
          // 2. Modify
          final actionResult = await action(currentList);

          return actionResult.fold(
            (failure) {
              AppLogger.error(
                '⚠️ Transaction aborted: Logic validation failed.',
                name: _logTag,
              );
              return Left(failure);
            },
            (result) async {
              // 3. Write back to storage
              try {
                final jsonString = _listToJsonString(currentList);
                await secureStorageService.write(
                  key: modelKey,
                  value: jsonString,
                );

                AppLogger.info(
                  '✅ Transaction committed successfully.',
                  name: _logTag,
                );
                return Right(result);
              } catch (writeError, s) {
                AppLogger.error(
                  '❌ Transaction failed during WRITE phase.',
                  error: writeError,
                  stackTrace: s,
                  name: _logTag,
                );
                return Left(
                  Failure(
                    message: 'Failed to write multiple items: ${writeError}',
                  ),
                );
              }
            },
          );
        },
      );
    } catch (e, s) {
      AppLogger.error(
        '❌ Critical Transaction Failure',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      return Left(Failure(message: 'Failed to write multiple items: ${e}'));
    }
  }

  // -----------------------------------------------------------------------------
  // Public Operations
  // -----------------------------------------------------------------------------

  /// Retrieves the list. Returns empty list [] if key does not exist.
  Future<Either<Failure, List<T>>> getAll() async {
    AppLogger.debug('Fetching all items...', name: _logTag);
    try {
      final jsonString = await secureStorageService.read(key: modelKey);

      if (jsonString == null || jsonString.isEmpty) {
        AppLogger.debug(
          'No data found (Key empty). Returning empty list.',
          name: _logTag,
        );
        // ignore: prefer_const_constructors
        return Right(<T>[]);
      }

      final list = _listFromJsonString(jsonString);
      AppLogger.info('fetched ${list.length} items.', name: _logTag);
      return Right(list);
    } catch (e, s) {
      AppLogger.error(
        '❌ Failed to getAll items',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      return Left(
        Failure(message: 'Failed to read items with key "${modelKey}": ${e}'),
      );
    }
  }

  Future<Either<Failure, List<T>>> getAllWhere({
    required bool Function(T) where,
  }) async {
    AppLogger.debug(
      'Fetching all items where condition is met...',
      name: _logTag,
    );
    try {
      final jsonString = await secureStorageService.read(key: modelKey);

      if (jsonString == null || jsonString.isEmpty) {
        AppLogger.debug(
          'No data found (Key empty). Returning empty list.',
          name: _logTag,
        );
        // ignore: prefer_const_constructors
        return Right(<T>[]);
      }

      final list = _listFromJsonString(jsonString);
      final filtered = list.where(where).toList();
      AppLogger.info('fetched ${filtered.length} items.', name: _logTag);
      return Right(filtered);
    } catch (e, s) {
      AppLogger.error(
        '❌ Failed to getAllWhere items',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      return Left(
        Failure(message: 'Failed to read items with key "${modelKey}": ${e}'),
      );
    }
  }

  /// Retrieves the Data. Returns null if key does not exist.
  Future<Either<Failure, T>> get() async {
    AppLogger.debug('Fetching single object...', name: _logTag);
    try {
      final jsonString = await secureStorageService.read(key: modelKey);

      if (jsonString == null || jsonString.isEmpty) {
        AppLogger.error('❌ Fetch failed: Key is empty/null', name: _logTag);
        return Left(
          Failure(message: 'Failed to read items with key "${modelKey}": null'),
        );
      }

      final data = _listFromJsonString(jsonString);
      if (data.isEmpty || data.firstOrNull == null) {
        AppLogger.error('❌ Fetch failed: List parsed but empty', name: _logTag);
        return Left(
          Failure(message: 'Failed to read items with key "${modelKey}": null'),
        );
      } else {
        AppLogger.info('✅ Object fetched successfully.', name: _logTag);
        return Right(data.first);
      }
    } catch (e, s) {
      AppLogger.error(
        '❌ Failed to get single object',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      return Left(
        Failure(message: 'Failed to read items with key "${modelKey}": ${e}'),
      );
    }
  }

  Future<Either<Failure, T>> getWhere({required bool Function(T) where}) async {
    AppLogger.debug(
      'Fetching single object where condition is met...',
      name: _logTag,
    );
    try {
      final jsonString = await secureStorageService.read(key: modelKey);

      if (jsonString == null || jsonString.isEmpty) {
        AppLogger.error('❌ Fetch failed: Key is empty/null', name: _logTag);
        return Left(
          Failure(message: 'Failed to read items with key "${modelKey}": null'),
        );
      }

      final data = _listFromJsonString(jsonString);
      final filtered = data.where(where);
      if (filtered.isEmpty || filtered.firstOrNull == null) {
        AppLogger.error(
          '❌ Fetch failed: No matching item found',
          name: _logTag,
        );
        return Left(
          Failure(message: 'Failed to read items with key "${modelKey}": null'),
        );
      } else {
        AppLogger.info('✅ Object fetched successfully.', name: _logTag);
        return Right(filtered.first);
      }
    } catch (e, s) {
      AppLogger.error(
        '❌ Failed to get single object',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      return Left(
        Failure(message: 'Failed to read items with key "${modelKey}": ${e}'),
      );
    }
  }

  /// Adds a new value to the list.
  Future<Either<Failure, List<T>>> create({required T value}) async {
    AppLogger.debug('Request to Create item', name: _logTag);
    return _editList<List<T>>(
      action: (list) async {
        if (list.contains(value)) {
          AppLogger.error(
            '⚠️ Creation skipped: Item already exists.',
            name: _logTag,
          );
          return const Left(Failure(message: 'Item already exists'));
        }
        list.add(value);
        return Right(list);
      },
    );
  }

  /// Adds multiple values.
  Future<Either<Failure, List<T>>> createMultiple({
    required List<T> values,
  }) async {
    AppLogger.debug(
      'Request to CreateMultiple (${values.length} items)',
      name: _logTag,
    );
    return _editList<List<T>>(
      action: (list) async {
        final uniqueValues = values.where((v) => !list.contains(v));
        if (uniqueValues.isEmpty) {
          AppLogger.debug(
            'All items already exist. No changes made.',
            name: _logTag,
          );
          return Right(list);
        }

        AppLogger.debug(
          'Adding ${uniqueValues.length} new unique items.',
          name: _logTag,
        );
        list.addAll(uniqueValues);
        return Right(list);
      },
    );
  }

  /// Updates a specific index.
  Future<Either<Failure, List<T>>> updateByIndex({
    required int index,
    required T value,
  }) async {
    AppLogger.debug('Request to UpdateByIndex ($index)', name: _logTag);
    return _editList<List<T>>(
      action: (list) async {
        if (index < 0 || index >= list.length) {
          AppLogger.error(
            '❌ Update failed: IndexOutOfBounds ($index)',
            name: _logTag,
          );
          return Left(
            Failure(
              message:
                  'Index $index is out of bounds for list of length ${list.length}',
            ),
          );
        }

        // Prevent creating duplicates via update
        final newItem = copyWith(list[index], value);
        if (list.contains(newItem) && list.indexOf(newItem) != index) {
          AppLogger.error(
            '⚠️ Update failed: Resulting item already exists elsewhere in list.',
            name: _logTag,
          );
          return const Left(Failure(message: 'Item already exists'));
        }

        list[index] = newItem;
        return Right(list);
      },
    );
  }

  /// Replaces the entire list.
  Future<Either<Failure, List<T>>> replaceAll({required List<T> values}) async {
    AppLogger.debug(
      'Request to ReplaceAll (Overwriting with ${values.length} items)',
      name: _logTag,
    );
    try {
      final jsonString = _listToJsonString(values);
      await secureStorageService.write(key: modelKey, value: jsonString);
      AppLogger.info('✅ ReplaceAll successful.', name: _logTag);
      return Right(values);
    } catch (e, s) {
      AppLogger.error(
        '❌ ReplaceAll failed',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      return Left(
        Failure(message: 'Failed to update items with key "${modelKey}": ${e}'),
      );
    }
  }

  /// Updates first item matching [where].
  Future<Either<Failure, T>> updateWhere({
    required bool Function(T) where,
    required T newValue,
  }) async {
    AppLogger.debug('Request to UpdateWhere...', name: _logTag);
    return _editList<T>(
      action: (list) async {
        final index = list.indexWhere(where);
        if (index == -1) {
          AppLogger.debug('UpdateWhere: No match found.', name: _logTag);
          return Right(newValue);
        }

        list[index] = copyWith(list[index], newValue);
        AppLogger.debug(
          'UpdateWhere: Match found and updated at index $index.',
          name: _logTag,
        );
        return Right(newValue);
      },
    );
  }

  /// Updates all items matching [test].
  Future<Either<Failure, int>> updateAllWhere({
    required bool Function(T) test,
    required T Function(T) transform,
  }) async {
    AppLogger.debug('Request to UpdateAllWhere...', name: _logTag);
    return _editList<int>(
      action: (list) async {
        int count = 0;
        for (int i = 0; i < list.length; i++) {
          if (test(list[i])) {
            list[i] = transform(list[i]);
            count++;
          }
        }
        AppLogger.info('UpdateAllWhere: Updated $count items.', name: _logTag);
        return Right(count);
      },
    );
  }

  /// Deletes by index.
  Future<Either<Failure, List<T>>> deleteByIndex({required int index}) async {
    AppLogger.debug('Request to DeleteByIndex ($index)', name: _logTag);
    return _editList<List<T>>(
      action: (list) async {
        if (index < 0 || index >= list.length) {
          AppLogger.error('❌ Delete failed: IndexOutOfBounds', name: _logTag);
          return Left(
            Failure(
              message:
                  'Index $index is out of bounds for list of length ${list.length}',
            ),
          );
        }
        list.removeAt(index);
        return Right(list);
      },
    );
  }

  /// Deletes where condition is true.
  Future<Either<Failure, List<T>>> deleteWhere({
    required bool Function(T) test,
  }) async {
    AppLogger.debug('Request to DeleteWhere...', name: _logTag);
    return _editList<List<T>>(
      action: (list) async {
        final originalLen = list.length;
        list.removeWhere(test);
        final removedCount = originalLen - list.length;
        AppLogger.info(
          'DeleteWhere: Removed $removedCount items.',
          name: _logTag,
        );
        return Right(list);
      },
    );
  }

  /// Clear the storage for this key.
  Future<Either<Failure, Unit>> clear() async {
    AppLogger.debug('Request to Clear storage.', name: _logTag);
    try {
      await secureStorageService.delete(key: modelKey);
      AppLogger.info('✅ Storage cleared.', name: _logTag);
      return const Right(unit);
    } catch (e, s) {
      AppLogger.error('❌ Clear failed', error: e, stackTrace: s, name: _logTag);
      return Left(Failure(message: 'Failed to clear storage: ${e}'));
    }
  }

  // -----------------------------------------------------------------------------
  // Seed Logic
  // -----------------------------------------------------------------------------

  Future<Either<Failure, List<T>>> seed() async {
    AppLogger.debug('Request to Seed data from assets...', name: _logTag);

    if (seedAssetPath == null) {
      AppLogger.error('❌ Seed failed: seedAssetPath is null.', name: _logTag);
      return const Left(Failure(message: 'Seed asset path is not set'));
    }

    return _editList<List<T>>(
      action: (currentList) async {
        try {
          AppLogger.debug('Reading asset: $seedAssetPath', name: _logTag);
          final jsonStr = await rootBundle.loadString(seedAssetPath!);
          final List<dynamic> jsonList = jsonDecode(jsonStr);

          bool changed = false;
          int addedCount = 0;

          for (final jsonItem in jsonList) {
            final item = fromJson(jsonItem as Map<String, dynamic>);
            if (!currentList.contains(item)) {
              currentList.add(item);
              changed = true;
              addedCount++;
            }
          }

          if (changed) {
            AppLogger.info(
              '✅ Seed success: Added $addedCount new items.',
              name: _logTag,
            );
          } else {
            AppLogger.debug(
              'Seed completed: No new items found to add.',
              name: _logTag,
            );
          }

          return Right(currentList);
        } catch (e, s) {
          AppLogger.error(
            '❌ Seed logic crashed',
            error: e,
            stackTrace: s,
            name: _logTag,
          );
          return Left(Failure(message: 'Failed to seed data: ${e}'));
        }
      },
    );
  }
}
