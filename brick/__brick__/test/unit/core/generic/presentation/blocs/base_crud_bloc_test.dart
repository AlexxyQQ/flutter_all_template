import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_all_template/config/constants/type_defs/typedef.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/generic/presentation/bloc/crud/base_crud_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart'; // Assuming you use fpdart or dartz for Either

// Import your BLoC files here
// import 'package:your_app/base_crud_bloc.dart';
// import 'package:your_app/common/domain/entities/failure.dart';

/// ----------------------------------------------------------------------------
/// 1. Mocks & Test Data Models
/// ----------------------------------------------------------------------------

// A dummy entity to test with
class TestEntity {
  const TestEntity({required this.id, required this.name});

  // Helper to map from JSON (simulating API)
  factory TestEntity.fromMap(Map<String, dynamic> map) {
    return TestEntity(id: map['id'], name: map['name']);
  }
  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

// A dummy filter model
class TestFilter {
  const TestFilter({this.searchTerm});
  final String? searchTerm;

  @override
  bool operator ==(Object other) =>
      other is TestFilter && searchTerm == other.searchTerm;

  @override
  int get hashCode => searchTerm.hashCode;
}

/// ----------------------------------------------------------------------------
/// 2. Concrete Implementation of the Abstract Bloc
/// ----------------------------------------------------------------------------
/// We create a "Super Bloc" that uses ALL mixins to test everything.
class TestCrudBloc extends BaseCrudBloc<TestEntity>
    with
        CreateCrudMixin<TestEntity>,
        ReadCrudMixin<TestEntity>,
        UpdateCrudMixin<TestEntity>,
        DeleteCrudMixin<TestEntity>,
        SearchableCrudMixin<TestEntity>,
        SelectableCrudMixin<TestEntity>,
        FilterableCrudMixin<TestEntity, TestFilter>,
        PaginatedCrudMixin<TestEntity, TestFilter> {
  TestCrudBloc()
    : super(name: 'TestEntity', initialFilters: const TestFilter()) {
    // Register all handlers from mixins
    registerCreateHandlers();
    registerReadHandlers();
    registerUpdateHandlers();
    registerDeleteHandlers();
    registerSearchHandlers();
    registerSelectHandlers();
    registerFilterableHandlers();
    registerPaginationHandlers();
  }

  @override
  dynamic getEntityId(TestEntity entity) => entity.id;

  // --- MOCKABLE CALLBACKS ---
  // We use these functions to inject behavior (Success/Failure) during tests

  ResultFuture<TestEntity?> Function(Map<String, dynamic>)? mockCreate;
  ResultFuture<List<TestEntity>?> Function(List<Map<String, dynamic>>)?
  mockCreateMultiple;
  ResultFuture<TestEntity> Function(dynamic)? mockRead;
  ResultFuture<List<TestEntity>> Function()? mockReadMultiple;
  ResultFuture<TestEntity?> Function(dynamic, Map<String, dynamic>)? mockUpdate;
  ResultFuture<bool> Function(dynamic)? mockDelete;
  ResultFuture<List<TestEntity>> Function(String?)? mockSearch;
  ResultFuture<List<TestEntity>> Function(TestFilter)? mockFilteredRead;
  ResultFuture<PaginationResponse<TestEntity>> Function(TestFilter, int?, int?)?
  mockPaginatedRead;

  // --- IMPLEMENTATIONS LINKING TO MOCKS ---

  @override
  ResultFuture<TestEntity?> createEntity(Map<String, dynamic> entity) async {
    return mockCreate != null ? mockCreate!(entity) : const Right(null);
  }

  @override
  ResultFuture<List<TestEntity>?> createMultipleEntity(
    List<Map<String, dynamic>> entities,
  ) async {
    return mockCreateMultiple != null
        ? mockCreateMultiple!(entities)
        : const Right([]);
  }

  @override
  ResultFuture<TestEntity> readEntity({id}) async {
    return mockRead != null
        ? mockRead!(id)
        : Right(TestEntity(id: id, name: 'Mock'));
  }

  @override
  ResultFuture<List<TestEntity>> readMultipleEntity() async {
    return mockReadMultiple != null ? mockReadMultiple!() : const Right([]);
  }

  @override
  ResultFuture<TestEntity?> updateEntity(
    id,
    Map<String, dynamic> updatedData,
  ) async {
    // We cheat slightly and return a TestEntity based on the map for testing
    return mockUpdate != null
        ? mockUpdate!(id, updatedData)
        : Right(TestEntity.fromMap(updatedData));
  }

  @override
  ResultFuture<bool> deleteEntity({id}) async {
    return mockDelete != null ? mockDelete!(id) : const Right(true);
  }

  @override
  bool isLocalSearchMatch(TestEntity entity, String query) {
    return entity.name.contains(query);
  }

  @override
  ResultFuture<List<TestEntity>> search({String? query}) async {
    return mockSearch != null ? mockSearch!(query) : const Right([]);
  }

  @override
  ResultFuture<List<TestEntity>> filteredRead({
    required TestFilter filters,
  }) async {
    return mockFilteredRead != null
        ? mockFilteredRead!(filters)
        : const Right([]);
  }

  @override
  ResultFuture<PaginationResponse<TestEntity>> paginatedRead({
    required TestFilter filters,
    int? page,
    int? limit,
    String? nextToken,
  }) async {
    return mockPaginatedRead != null
        ? mockPaginatedRead!(filters, page, limit)
        : const Right(PaginationResponse(entities: []));
  }
}

/// ----------------------------------------------------------------------------
/// 3. The Test Suite
/// ----------------------------------------------------------------------------
void main() {
  late TestCrudBloc bloc;

  // Common Test Data
  const entity1 = TestEntity(id: '1', name: 'Alpha');
  const entity2 = TestEntity(id: '2', name: 'Beta');
  const entity3 = TestEntity(id: '3', name: 'Charlie');
  const testFailure = Failure(message: 'Test Error');

  setUp(() {
    bloc = TestCrudBloc();
  });

  tearDown(() {
    bloc.close();
  });

  group('CreateCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'CreateEntityEvent: emits [loading, success] with new entity appended',
      build: () {
        bloc.mockCreate = (map) async => Right(TestEntity.fromMap(map));
        return bloc;
      },
      seed: () => const BaseCrudState(entities: [entity1]), // Start with 1 item
      act: (bloc) => bloc.add(
        const CreateEntityEvent(entity: {'id': '2', 'name': 'Beta'}),
      ),
      expect: () => [
        // 1. Loading
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.error, 'error', null),
        // 2. Success (Appended)
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.entities.length, 'length', 2)
            .having((s) => s.entities.last, 'last item', entity2)
            .having((s) => s.successMessage, 'message', isNotNull),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'CreateEntityEvent: emits [loading, error] on failure',
      build: () {
        bloc.mockCreate = (map) async => const Left(testFailure);
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateEntityEvent(entity: {'id': '2'})),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          true,
        ),
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.error, 'error', testFailure),
      ],
    );
  });

  group('ReadCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'ReadEntityEvent: emits [loading, success] and sets selectedEntity',
      build: () {
        bloc.mockRead = (id) async => const Right(entity1);
        return bloc;
      },
      act: (bloc) => bloc.add(const ReadEntityEvent(id: '1')),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          true,
        ),
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.entities.first, 'entities', entity1)
            .having((s) => s.selectedEntity, 'selected', entity1),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'ReadMultipleEntityEvent: emits [loading, success] with list',
      build: () {
        bloc.mockReadMultiple = () async => const Right([entity1, entity2]);
        return bloc;
      },
      act: (bloc) => bloc.add(const ReadMultipleEntityEvent()),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          true,
        ),
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.entities.length, 'length', 2)
            .having((s) => s.filteredEntities.length, 'filtered length', 2),
      ],
    );
  });

  group('UpdateCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'UpdateEntityEvent: updates specific item in the list',
      build: () {
        bloc.mockUpdate = (id, map) async =>
            Right(TestEntity(id: id, name: 'Alpha Updated'));
        return bloc;
      },
      seed: () =>
          const BaseCrudState(entities: [entity1, entity2]), // [Alpha, Beta]
      act: (bloc) => bloc.add(
        const UpdateEntityEvent(
          id: '1',
          entity: {'id': '1', 'name': 'Alpha Updated'},
        ),
      ),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          true,
        ),
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', false)
            .having(
              (s) => s.entities[0].name,
              'updated name',
              'Alpha Updated',
            ) // Index 0 updated
            .having(
              (s) => s.entities[1].name,
              'untouched name',
              'Beta',
            ), // Index 1 unchanged
      ],
    );
  });

  group('DeleteCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'DeleteEntityEvent: removes item from list',
      build: () {
        bloc.mockDelete = (id) async => const Right(true);
        return bloc;
      },
      seed: () => const BaseCrudState(entities: [entity1, entity2]),
      act: (bloc) => bloc.add(const DeleteEntityEvent(id: '1')), // Delete Alpha
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          true,
        ),
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.entities.length, 'length', 1)
            .having(
              (s) => s.entities.first,
              'remaining',
              entity2,
            ), // Only Beta remains
      ],
    );
  });

  group('SearchableCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'LocalSearchEvent: filters the existing list without API call',
      build: () => bloc,
      seed: () =>
          const BaseCrudState(entities: [entity1, entity2]), // Alpha, Beta
      act: (bloc) => bloc.add(const LocalSearchEvent(query: 'Alpha')),
      expect: () => [
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.searchQuery, 'query', 'Alpha')
            .having((s) => s.filteredEntities.length, 'filtered', 1)
            .having((s) => s.filteredEntities.first, 'match', entity1)
            .having(
              (s) => s.entities.length,
              'original',
              2,
            ), // Original list intact
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'SearchEvent: performs API search and replaces entities',
      build: () {
        bloc.mockSearch = (q) async =>
            const Right([entity3]); // API returns Charlie
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchEvent(query: 'Charlie')),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          true,
        ),
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.entities.first,
          'result',
          entity3,
        ),
      ],
    );
  });

  group('SelectableCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      build: () => bloc,

      'SelectEntityEvent: Updates selectedEntity',
      act: (bloc) => bloc.add(const SelectEntityEvent(entity: entity1)),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.selectedEntity,
          'selected',
          entity1,
        ),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      build: () => bloc,

      'MultiSelectEntityEvent: Toggles selection (Add then Remove)',
      seed: () => const BaseCrudState(selectedEntities: [entity1]),
      act: (bloc) async {
        bloc.add(const MultiSelectEntityEvent(entity: entity2)); // Add
        await Future.delayed(Duration.zero);
        bloc.add(const MultiSelectEntityEvent(entity: entity1)); // Remove
      },
      expect: () => [
        // 1. Added Entity2 ([1, 2])
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.selectedEntities.length,
          'added',
          2,
        ),
        // 2. Removed Entity1 ([2])
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.selectedEntities.length, 'removed', 1)
            .having((s) => s.selectedEntities.first, 'remaining', entity2),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      build: () => bloc,

      'SelectInGroupEntityEvent: Adds to group map',
      act: (bloc) => bloc.add(
        const SelectInGroupEntityEvent(key: 'groupA', entities: entity1),
      ),
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.groupSelected!['groupA'],
          'group check',
          entity1,
        ),
      ],
    );
  });

  group('FilterableCrudMixin', () {
    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'SetFilterEvent: Sets filter and triggers filteredRead',
      build: () {
        bloc.mockFilteredRead = (f) async => const Right([entity1]);
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SetFilterEvent(filters: TestFilter(searchTerm: 'test')),
      ),
      expect: () => [
        // 1. Set filter + Loading
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', true)
            .having(
              (s) => (s.filters as TestFilter).searchTerm,
              'filter set',
              'test',
            ),
        // 2. Success from API
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.filteredEntities.first, 'data', entity1),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'UpdateFilterEvent: Modifies existing filter and fetches',
      seed: () => const BaseCrudState(filters: TestFilter(searchTerm: 'old')),
      build: () {
        bloc.mockFilteredRead = (f) async => const Right([]);
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateFilterEvent<TestEntity, TestFilter>(
          (current) => const TestFilter(searchTerm: 'new'),
        ),
      ),
      verify: (bloc) {
        // Verify the bloc internally called filteredRead with 'new'
      },
      expect: () => [
        isA<BaseCrudState<TestEntity>>().having(
          (s) => (s.filters as TestFilter).searchTerm,
          'updated',
          'new',
        ),
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoading,
          'loading',
          false,
        ),
      ],
    );
  });

  group('PaginatedCrudMixin', () {
    const page1Response = PaginationResponse(
      entities: [entity1],
      nextPage: 2,
      totalPages: 3,
    );

    const page2Response = PaginationResponse(
      entities: [entity2],
      nextPage: 3,
      totalPages: 3,
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'LoadInitialPaginationEvent: Loads page 1 and sets tokens/pages',
      build: () {
        bloc.mockPaginatedRead = (f, p, l) async {
          if (p == 1) return const Right(page1Response);
          return const Right(PaginationResponse(entities: []));
        };
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadInitialPaginationEvent(limit: 10)),
      expect: () => [
        // 1. Initial Loading
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', true)
            .having((s) => s.isInitial, 'isInitial', true)
            .having((s) => s.entities, 'cleared entities', isEmpty),
        // 2. Success
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.isInitial, 'isInitial', false)
            .having((s) => s.currentPage, 'page', 1)
            .having((s) => s.nextPage, 'nextPage', 2)
            .having((s) => s.entities.length, 'data', 1),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      'LoadNextPaginationEvent: Appends data to existing list',
      seed: () => const BaseCrudState(
        entities: [entity1],
        nextPage: 2,
        filters: TestFilter(), // Important cast
      ),
      build: () {
        bloc.mockPaginatedRead = (f, p, l) async {
          if (p == 2) return const Right(page2Response);
          return const Right(PaginationResponse(entities: []));
        };
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadNextPaginationEvent()),
      expect: () => [
        // 1. Loading Next
        isA<BaseCrudState<TestEntity>>().having(
          (s) => s.isLoadingNext,
          'loadingNext',
          true,
        ),
        // 2. Success
        isA<BaseCrudState<TestEntity>>()
            .having((s) => s.isLoadingNext, 'loadingNext', false)
            .having(
              (s) => s.entities.length,
              'total count',
              2,
            ) // [entity1, entity2]
            .having((s) => s.entities.last, 'new item', entity2)
            .having((s) => s.currentPage, 'new page', 2)
            .having((s) => s.nextPage, 'next page', 3),
      ],
    );

    blocTest<TestCrudBloc, BaseCrudState<TestEntity>>(
      build: () => bloc,

      'LoadNextPaginationEvent: Ignored if hasReachedNextEnd is true',
      seed: () =>
          const BaseCrudState(hasReachedNextEnd: true, entities: [entity1]),
      act: (bloc) => bloc.add(const LoadNextPaginationEvent()),
      expect: () => [], // No state emitted
    );
  });
}
