# Generic building blocks

Small, composable pieces shared by features. See `lib/features/example/` for a
complete slice that uses them (including a plain-Material screen), and `bricks/feature_brick/` to generate a new one.

| Piece | File | Use for |
|---|---|---|
| `PageRequest` / `PageResult<T>` | `domain/entities/page.dart` | Repository paging contract. Page-number **and** cursor APIs: the bloc passes the previous `nextCursor` and the next page number. |
| `PagedListBloc<T, Q>` + `PagedState<T, Q>` | `presentation/bloc/paged_list_bloc.dart` | Infinite lists: `PagedListStarted`, `PagedListRefreshed`, `PagedListNextPageRequested` (droppable), `PagedListQueryChanged<Q>` (debounced + restartable). A failed refresh/load-more keeps loaded items; a failed *query change* clears the old query's items and paging position. Extend it to add feature events and wrap feature mutations in `serialized(...)`: mutations never interleave with load results, and a load fetched while a mutation ran is fetched again. |
| `debounceRestartable` | `presentation/bloc/event_transformers.dart` | Search-as-you-type transformer for your own blocs. |
| `JsonCollectionStore<T>` | `data/json_collection_store.dart` | Small id-keyed offline cache on `IPreferencesStore`; serialised writes; throws `StorageException` / `CacheMissException`. Not for secrets or large data. |
| `AsyncLock` | `data/async_lock.dart` | FIFO mutex for read-modify-write sequences. |

Rules these follow: handlers return `Future<void>` and declare their concurrency;
blocs never call `.tr()` (widgets show `failure.displayText`, which
translates `Failure.messageKey`); events are typed (no `Map<String, dynamic>`); ids are `String`.
