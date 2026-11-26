# flutter_feature brick

Generates a clean-architecture feature slice (paged, searchable list with create, read,
update and delete) for a project made from this template. It is built on
`lib/core/generic/` (`PagedListBloc`, `PageRequest`/`PageResult`, `JsonCollectionStore`)
and mirrors the reference slice in `lib/features/example/` (Todos).

## Usage

Run from the project root (next to `lib/`):

```bash
mason get
mason make flutter_feature
```

| Prompt | Meaning | Default |
|---|---|---|
| `feature_name` | Singular name in any case (`note`, `user_profile`) | `note` |
| `use_local_datasource` | Offline cache: reads are cached and served when offline | `false` |
| `use_params` | Typed `Create/Update...Params` and `...Query` classes (off: plain arguments and a `String` query) | `true` |

Non-interactive: `mason make flutter_feature -c config.json` with
`{"feature_name": "note", "use_local_datasource": true, "use_params": true}`.

## Output (`feature_name: note`)

```
lib/features/note/
├── domain/        entities/note.dart, params/note_params.dart (use_params), usecases/ (list, get, create, update, delete), repositories/
├── data/          models/, data_sources/remote/, data_sources/local/ (use_local_datasource), repositories/
└── presentation/bloc/   note_list_bloc.dart, note_list_event.dart
```

The post-gen hook also adds `ApiPaths.notes = '/notes'` to
`lib/config/constants/api/api_paths.dart`, removes the folders of disabled options and
formats the result.

## After generation

1. Add your fields to the entity, model and params.
2. `dart run build_runner build --delete-conflicting-outputs` (Freezed, JSON and
   injectable registration).
3. Adapt the API contract documented at the top of the remote data source.
4. Build the screen: `BlocProvider(create: (_) => sl<NoteListBloc>())` plus a `ListView`
   over `state.items`. Copy `lib/features/example/presentation/views/screens/todo_list_screen.dart`
   and add its route and translations.

Presentation depends on the use cases (one class per action, named parameters, thin
forwarders to the repository interface; `CreateNoteUseCase` trims the title), never on the
repository or data sources.

Data sources throw `AppException`s, repositories convert them once with `guard()`, and
blocs never translate (they expose `Failure.message`, a localization key).
