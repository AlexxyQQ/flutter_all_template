# Base CRUD Bloc

A generic, mixin-based BLoC foundation for standard Create / Read / Update / Delete operations. Extend `BaseCrudBloc<Entity>` and opt-in to only the capabilities your feature needs.

## Files

| File | Purpose |
|------|---------|
| `base_crud_bloc.dart` | Abstract base class + freezed event/state wiring |
| `base_crud_event.dart` | Base event type |
| `base_crud_state.dart` | Immutable state holding entities, loading, error, pagination |
| `mixin/create_mixin.dart` | `CreateCrudMixin` — handles `CreateEntityEvent` |
| `mixin/read_mixin.dart` | `ReadCrudMixin` — handles `ReadEntityEvent` / `ReadMultipleEntityEvent` |
| `mixin/update_mixin.dart` | `UpdateCrudMixin` — handles `UpdateEntityEvent` |
| `mixin/delete_mixin.dart` | `DeleteCrudMixin` — handles `DeleteEntityEvent` |
| `mixin/paginated_crud_mixin.dart` | `PaginatedCrudMixin` — handles paginated list loading |
| `mixin/searchable_mixin.dart` | `SearchableMixin` — client-side search over `entities` |
| `mixin/selectable_mixin.dart` | `SelectableMixin` — tracks `selectedEntity` |
| `mixin/filterable_crud_mixin.dart` | `FilterableCrudMixin` — tracks arbitrary filter state |
| `crud_exports.dart` | Barrel export for all CRUD types |

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.x.x
  fpdart: ^1.2.0
  equatable: ^2.x.x
  freezed_annotation: ^2.x.x
  easy_localization: ^3.x.x

dev_dependencies:
  freezed: ^3.x.x
  build_runner: ^2.x.x
```

## Usage

### 1. Define your entity

```dart
class Product {
  const Product({required this.id, required this.name, required this.price});
  final int    id;
  final String name;
  final double price;
}
```

### 2. Create the Bloc — mix in only what you need

```dart
@injectable
class ProductBloc extends BaseCrudBloc<Product>
    with ReadCrudMixin<Product>, CreateCrudMixin<Product>, DeleteCrudMixin<Product> {

  ProductBloc({required IProductRepository repository})
      : _repository = repository,
        super(name: 'Product') {
    registerReadHandlers();
    registerCreateHandlers();
    registerDeleteHandlers();
  }

  final IProductRepository _repository;

  @override
  int getEntityId(Product entity) => entity.id;

  // ---- ReadCrudMixin contract ----
  @override
  ResultFuture<Product> readEntity({dynamic id}) => _repository.getById(id as int);

  @override
  ResultFuture<List<Product>> readMultipleEntity() => _repository.getAll();

  // ---- CreateCrudMixin contract ----
  @override
  ResultFuture<Product> createEntity(Map<String, dynamic> data) =>
      _repository.create(Product.fromJson(data));

  // ---- DeleteCrudMixin contract ----
  @override
  ResultFuture<void> deleteEntity(dynamic id) => _repository.delete(id as int);
}
```

### 3. Dispatch events from the UI

```dart
// Load list
context.read<ProductBloc>().add(const ReadMultipleEntityEvent());

// Load single
context.read<ProductBloc>().add(const ReadEntityEvent(id: 42));

// Create
context.read<ProductBloc>().add(CreateEntityEvent(data: product.toJson()));

// Delete
context.read<ProductBloc>().add(DeleteEntityEvent(id: 42));
```

### 4. Consume state

```dart
BlocBuilder<ProductBloc, BaseCrudState<Product>>(
  builder: (context, state) {
    if (state.isLoading) return const CircularProgressIndicator();
    if (state.error != null) return Text(state.error!.message);
    return ListView(
      children: state.entities.map((p) => Text(p.name)).toList(),
    );
  },
)
```

## Available State Fields

| Field | Type | Description |
|-------|------|-------------|
| `isLoading` | `bool` | True while any async operation is running |
| `error` | `Failure?` | Last error, null on success |
| `successMessage` | `String?` | Localisation key for success toast |
| `entities` | `List<Entity>` | Full list returned by `readMultipleEntity` |
| `filteredEntities` | `List<Entity>` | View after search/filter applied |
| `selectedEntity` | `Entity?` | Set by `readEntity` or `SelectableMixin` |
| `page` / `hasMore` | `int` / `bool` | Pagination state (via `PaginatedCrudMixin`) |
| `filters` | `dynamic` | Arbitrary filter object (via `FilterableCrudMixin`) |

## Mixin Reference

| Mixin | Events registered | Abstract methods to implement |
|-------|-------------------|-------------------------------|
| `ReadCrudMixin` | `ReadEntityEvent`, `ReadMultipleEntityEvent` | `readEntity`, `readMultipleEntity` |
| `CreateCrudMixin` | `CreateEntityEvent` | `createEntity` |
| `UpdateCrudMixin` | `UpdateEntityEvent` | `updateEntity` |
| `DeleteCrudMixin` | `DeleteEntityEvent` | `deleteEntity` |
| `PaginatedCrudMixin` | `LoadNextPageEvent` | `readPage` |
| `SearchableMixin` | `SearchEntityEvent` | `matchesQuery` |
| `SelectableMixin` | `SelectEntityEvent` | _(none — purely state)_ |
| `FilterableCrudMixin` | `ApplyFiltersEvent` | `applyFilters` |

## Copying to a New Project

1. Copy the entire `crud/` folder.
2. Add `flutter_bloc`, `fpdart`, `equatable`, `freezed_annotation` to `pubspec.yaml`.
3. Run `build_runner` to regenerate `base_crud_bloc.freezed.dart`.
4. Extend `BaseCrudBloc` in your feature blocs and mix in what you need.
