import 'dart:convert';

import 'package:flutter_all_template/core/common/domain/services/logger/logger_service.dart';
import 'package:flutter_all_template/core/common/domain/services/storage/secure_storage_service.dart';
import 'package:flutter_all_template/core/generic/data/data_sources/local/secure_storage_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'secure_storage_data_source_test.mocks.dart';

// -----------------------------------------------------------------------------
// 2. Mocks Configuration
// -----------------------------------------------------------------------------

// Generate Mocks for both Storage AND Logger
@GenerateMocks([SecureStorageService, AppLogger])
class TestUser {
  TestUser(this.id, this.name);

  factory TestUser.fromJson(Map<String, dynamic> json) =>
      TestUser(json['id'], json['name']);
  final int id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// The Concrete Implementation of your Abstract Class
class TestUserStorage extends ISecureStorageDataSource<TestUser> {
  TestUserStorage(SecureStorageService service)
    : super(secureStorageService: service, modelKey: 'test_users');

  @override
  TestUser fromJson(Map<String, dynamic> json) => TestUser.fromJson(json);

  @override
  Map<String, dynamic> toJson(TestUser object) => object.toJson();

  @override
  TestUser copyWith(TestUser existingItem, TestUser newValue) {
    return TestUser(newValue.id, newValue.name);
  }
}

// -----------------------------------------------------------------------------
// 3. The Test Suite
// -----------------------------------------------------------------------------

void main() {
  late MockSecureStorageService mockStorage;
  late MockAppLogger mockLogger;
  late TestUserStorage dataSource;

  // Test Data
  final user1 = TestUser(1, 'Alice');
  final user2 = TestUser(2, 'Bob');
  final user3 = TestUser(3, 'Charlie');

  const testKey = 'test_users';

  setUp(() async {
    // 1. Reset GetIt to clear any previous registrations from other test files
    await GetIt.I.reset();

    // 2. Initialize Mocks
    mockStorage = MockSecureStorageService();
    mockLogger = MockAppLogger();

    // 3. Register the Mock Logger in GetIt
    // This allows AppLogger.debug() -> GetIt.I<ILoggerService>().debug() to work without crashing
    GetIt.I.registerSingleton<ILoggerService>(mockLogger);

    // 4. Initialize the Data Source
    dataSource = TestUserStorage(mockStorage);
  });

  tearDown(() {
    // Clean up GetIt after every test
    GetIt.I.reset();
  });

  group('ISecureStorageDataSource - Read Operations', () {
    test('getAll returns empty list when storage is null', () async {
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => null);

      final result = await dataSource.getAll();

      expect(result.isRight(), true);
      result.fold((l) => fail('Should be Right'), (r) => expect(r, isEmpty));
    });

    test('getAll returns parsed list when storage has data', () async {
      final jsonString = jsonEncode([user1.toJson(), user2.toJson()]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => jsonString);

      final result = await dataSource.getAll();

      expect(result.isRight(), true);
      result.fold((l) => fail('Should be Right'), (list) {
        expect(list.length, 2);
        expect(list[0], user1);
        expect(list[1], user2);
      });

      // Optional: Verify logger was called
      verify(mockLogger.i(any, name: anyNamed('name'))).called(1);
    });

    test('getAll returns Failure when Exception occurs', () async {
      when(
        mockStorage.read(key: testKey),
      ).thenThrow(Exception('Storage error'));

      final result = await dataSource.getAll();

      expect(result.isLeft(), true);
      // Verify error logger was called
      verify(
        mockLogger.e(
          any,
          error: anyNamed('error'),
          stackTrace: anyNamed('stackTrace'),
          name: anyNamed('name'),
        ),
      ).called(1);
    });
  });

  group('ISecureStorageDataSource - Create Operations', () {
    test('create adds item to empty list and writes to storage', () async {
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => null);

      final result = await dataSource.create(value: user1);

      expect(result.isRight(), true);

      final expectedJson = jsonEncode([user1.toJson()]);
      verify(mockStorage.write(key: testKey, value: expectedJson)).called(1);
    });

    test('create returns Failure if item already exists', () async {
      final startJson = jsonEncode([user1.toJson()]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => startJson);

      final result = await dataSource.create(value: user1);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message.contains('itemAlreadyExists'), true),
        (r) => fail('Should fail'),
      );
      verifyNever(
        mockStorage.write(key: anyNamed('key'), value: anyNamed('value')),
      );
    });

    test('createMultiple adds only unique new items', () async {
      final startJson = jsonEncode([user1.toJson()]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => startJson);

      final result = await dataSource.createMultiple(values: [user1, user2]);

      expect(result.isRight(), true);
      result.fold((l) => fail('Should work'), (list) {
        expect(list.length, 2);
        expect(list.contains(user2), true);
      });

      final expectedJson = jsonEncode([user1.toJson(), user2.toJson()]);
      verify(mockStorage.write(key: testKey, value: expectedJson)).called(1);
    });
  });

  group('ISecureStorageDataSource - Update Operations', () {
    test('updateByIndex updates item successfully', () async {
      final startJson = jsonEncode([user1.toJson(), user2.toJson()]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => startJson);

      final result = await dataSource.updateByIndex(index: 0, value: user3);

      expect(result.isRight(), true);

      final expectedJson = jsonEncode([user3.toJson(), user2.toJson()]);
      verify(mockStorage.write(key: testKey, value: expectedJson)).called(1);
    });

    test('updateByIndex returns Failure on Out of Bounds', () async {
      when(
        mockStorage.read(key: testKey),
      ).thenAnswer((_) async => jsonEncode([]));

      final result = await dataSource.updateByIndex(index: 5, value: user1);

      expect(result.isLeft(), true);
      verifyNever(
        mockStorage.write(key: anyNamed('key'), value: anyNamed('value')),
      );
    });

    test('updateWhere updates the correct item', () async {
      final startJson = jsonEncode([user1.toJson(), user2.toJson()]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => startJson);

      final result = await dataSource.updateWhere(
        where: (u) => u.id == 2,
        newValue: user3,
      );

      expect(result.isRight(), true);
      result.fold((l) => null, (success) => expect(success, true));

      final expectedJson = jsonEncode([user1.toJson(), user3.toJson()]);
      verify(mockStorage.write(key: testKey, value: expectedJson)).called(1);
    });
  });

  group('ISecureStorageDataSource - Delete Operations', () {
    test('deleteByIndex removes item and updates storage', () async {
      final startJson = jsonEncode([user1.toJson(), user2.toJson()]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => startJson);

      final result = await dataSource.deleteByIndex(index: 0);

      expect(result.isRight(), true);
      result.fold((l) => null, (list) => expect(list.length, 1));

      final expectedJson = jsonEncode([user2.toJson()]);
      verify(mockStorage.write(key: testKey, value: expectedJson)).called(1);
    });

    test('deleteWhere removes matching items', () async {
      final startJson = jsonEncode([
        user1.toJson(),
        user2.toJson(),
        user3.toJson(),
      ]);
      when(mockStorage.read(key: testKey)).thenAnswer((_) async => startJson);

      final result = await dataSource.deleteWhere(where: (u) => u.id.isOdd);

      expect(result.isRight(), true);
      result.fold((l) => null, (list) {
        expect(list.length, 1);
        expect(list.first, user2);
      });
    });

    test('clear removes key from storage', () async {
      final result = await dataSource.clear();

      expect(result.isRight(), true);
      verify(mockStorage.delete(key: testKey)).called(1);
    });
  });
}
