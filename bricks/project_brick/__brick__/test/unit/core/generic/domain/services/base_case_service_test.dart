import 'package:flutter_all_template/core/common/domain/services/logger/logger_service.dart';
import 'package:flutter_all_template/core/generic/domain/services/base_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';

import '../../data/data_source/local/secure_storage_data_source_test.mocks.dart';

@GenerateMocks([AppLogger])
/// ----------------------------------------------------------------------------
/// 1. Concrete Implementation for Testing
/// ----------------------------------------------------------------------------
class TestCacheService extends BaseSingleCacheService<String> {
  TestCacheService({Duration? ttl, bool enableCache = true})
    : super(key: 'test_resource_key', ttl: ttl, enableCache: enableCache);

  // Spying variables
  int fetchCallCount = 0;
  Duration delay = const Duration(milliseconds: 50);
  String returnValue = 'FetchedData';
  bool shouldThrowError = false;

  @override
  Future<String?> fetch() async {
    fetchCallCount++;

    // Simulate async work
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    if (shouldThrowError) {
      throw Exception('Network Error');
    }

    return returnValue;
  }
}

/// ----------------------------------------------------------------------------
/// 2. The Test Suite
/// ----------------------------------------------------------------------------
void main() {
  late TestCacheService service;
  late MockAppLogger mockLogger;

  setUp(() async {
    await GetIt.I.reset();

    // Default setup: No TTL, Cache Enabled
    service = TestCacheService();
    mockLogger = MockAppLogger();

    GetIt.I.registerSingleton<ILoggerService>(mockLogger);
  });

  tearDown(() {
    // Clean up GetIt after every test
    GetIt.I.reset();
  });

  group('BaseSingleCacheService', () {
    test('get() should trigger fetch() on the first call', () async {
      // Act
      final result = await service.get();

      // Assert
      expect(result, 'FetchedData');
      expect(service.fetchCallCount, 1);

      // Verify it's now in memory
      expect(service.getSync(), 'FetchedData');
    });

    test('getSync() should return null if data is not yet cached', () {
      expect(service.getSync(), isNull);
    });

    test('getSync() should return data if it is already cached', () async {
      // Arrange
      await service.get(); // Load it

      // Act
      final result = service.getSync();

      // Assert
      expect(result, 'FetchedData');
    });

    test(
      'Request Coalescing: Simultaneous calls return the same Future',
      () async {
        // Arrange
        service.delay = const Duration(milliseconds: 200);

        // Act
        final future1 = service.get();
        final future2 = service.get();

        // Assert
        // 1. They must be the EXACT same object instance
        expect(future1, same(future2));

        // 2. Wait for completion
        await future1;
        await future2;

        // 3. Fetch should only run once
        expect(service.fetchCallCount, 1);
      },
    );

    test('Caching: Subsequent calls should NOT trigger fetch()', () async {
      // Arrange
      await service.get(); // 1st call
      service.fetchCallCount = 0; // Reset counter

      // Act
      final result = await service.get(); // 2nd call

      // Assert
      expect(result, 'FetchedData');
      expect(service.fetchCallCount, 0); // Should be 0
    });

    test('TTL: Should re-fetch if data is expired', () async {
      // Arrange: Create a service with a very short TTL
      service = TestCacheService(ttl: const Duration(milliseconds: 100));

      await service.get(); // Initial fetch
      expect(service.fetchCallCount, 1);

      // Act: Wait for TTL to expire
      await Future.delayed(const Duration(milliseconds: 101));

      // Check sync first (should be null because it expired)
      expect(service.getSync(), isNull);

      // Call get again
      await service.get();

      // Assert: Should have fetched again
      expect(service.fetchCallCount, 2);
    });

    test('enableCache = false should disable caching and coalescing', () async {
      // Arrange
      service = TestCacheService(enableCache: false);

      // Act
      await service.get();
      await service.get();

      // Assert
      expect(service.fetchCallCount, 2); // Fetched every time
      expect(service.getSync(), isNull); // Never stored in memory
    });

    test('invalidate() should remove item from cache', () async {
      // Arrange
      await service.get();
      expect(service.getSync(), isNotNull);

      // Act
      service.invalidate();

      // Assert
      expect(service.getSync(), isNull);
    });

    test('set() should manually insert data without fetching', () async {
      // Act
      service.set('ManualData');

      // Assert
      expect(service.getSync(), 'ManualData');

      // Verify calling get() returns this data without fetching
      await service.get();
      expect(service.fetchCallCount, 0);
    });

    test(
      'Error Handling: Should propagate error and clean up loading state',
      () async {
        // Arrange
        service.shouldThrowError = true;

        // Act & Assert
        // 1. Expect an exception
        expect(() async => service.get(), throwsException);

        // 2. Ensure we can try again (loading state should be cleared)
        // If the loading state wasn't cleared, this next line would return the old error future
        // or hang. By resetting the error flag, we prove the service is "unblocked".
        service.shouldThrowError = false;

        try {
          await service.get();
        } catch (_) {
          // Ignore the previous error if it lingered (it shouldn't)
        }

        // If logic is correct, we can now fetch successfully
        final result = await service.get();
        expect(result, 'FetchedData');
      },
    );
  });
}
