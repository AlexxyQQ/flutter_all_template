# Generic building blocks

Small, composable pieces shared by features. See `lib/features/example/` for a
complete slice that uses them, and `bricks/feature_brick/` to generate a new one.

| Piece | File | Use for |
|---|---|---|
| `PageRequest` / `PageResult<T>` | `domain/entities/page.dart` | Repository paging contract. Page-number **and** cursor APIs: the bloc passes the previous `nextCursor` and the next page number. |
| `LoadState<T>` + `LoadCubit<T>` | `presentation/bloc/load_state.dart` | One value (profile, settings, detail page): `initial → inProgress → success/failure`, keeps the previous value on reload/failure. |
| `PagedListBloc<T, Q>` + `PagedState<T, Q>` | `presentation/bloc/paged_list_bloc.dart` | Infinite lists: `PagedListStarted`, `PagedListRefreshed`, `PagedListNextPageRequested` (droppable), `PagedListQueryChanged<Q>` (debounced + restartable). Errors never wipe loaded items. Extend it to add feature events. |
| `SelectionCubit<K>` | `presentation/bloc/selection_cubit.dart` | Multi-select of item ids, kept out of the list state. |
| `debounceRestartable` | `presentation/bloc/event_transformers.dart` | Search-as-you-type transformer for your own blocs. |
| `PaginationListView<T>` | `presentation/views/widgets/pagination_list_view_widget.dart` | Material list bound to a `PagedListBloc` (placeholders, pull-to-refresh, load-more). |
| `JsonCollectionStore<T>` | `data/json_collection_store.dart` | Small id-keyed offline cache on `PreferencesStore`; serialised writes; throws `StorageException` / `CacheMissException`. Not for secrets or large data. |
| `AsyncLock` | `data/async_lock.dart` | FIFO mutex for read-modify-write sequences. |
| `SingleFlightCache<T>` | `data/single_flight_cache.dart` | In-memory single value with TTL and request coalescing. |

Rules these follow: handlers return `Future<void>` and declare their concurrency;
blocs never call `.tr()` (`Failure.message` is a localization key the widget
translates); events are typed (no `Map<String, dynamic>`); ids are `String`.
