# flutter_feature brick

Generates a clean-architecture feature slice for `flutter_all_template`: a paged,
searchable list with create/read/update/delete, built on the shared generic pieces in
`lib/core/generic/` (`PagedListBloc`, `PageRequest`/`PageResult`, `JsonCollectionStore`).
The reference implementation it mirrors is `lib/features/example/` (a `Todo` slice).

## Usage

Run from the **project root** (next to `lib/`):

```bash
mason get
mason make flutter_feature
```

| Prompt | Meaning | Default |
|--------|---------|---------|
| `feature_name` | Singular feature name, any case (`note`, `user_profile`, `UserProfile`) | `note` |
| `use_local_datasource` | Add an offline cache: reads are cached and served from the cache when offline | `false` |
| `use_params` | Typed `Create…Params` / `Update…Params` / `…Query` classes. Off: `create…({required String title})`, `update…(entity)` and a `String` search query | `true` |

Non-interactive: `mason make flutter_feature -c config.json` with
`{"feature_name": "note", "use_local_datasource": true, "use_params": true}`.

## What gets generated (`feature_name: note`)

```
lib/features/note/
├── domain/                                   # pure Dart
│   ├── entities/note.dart                    # Freezed entity (id, title, updatedAt)
│   ├── params/note_params.dart               # use_params: CreateNoteParams, UpdateNoteParams, NoteQuery
│   └── repositories/note_repository.dart     # INoteRepository (returns ResultFuture)
├── data/
│   ├── models/note_model.dart                # Freezed + JSON, toEntity()/fromEntity()
│   ├── data_sources/
│   │   ├── remote/note_remote_data_source.dart  # ApiClient: GET/POST/PATCH/DELETE, throws AppException
│   │   └── local/note_local_data_source.dart    # use_local_datasource: JsonCollectionStore cache
│   └── repositories/note_repository_impl.dart   # @LazySingleton(as: INoteRepository), guard()
└── presentation/bloc/
    ├── note_list_bloc.dart                   # @injectable, extends PagedListBloc<Note, NoteQuery>
    └── note_list_event.dart                  # NoteCreated, NoteDeleted
```

The post-generation hook also:

- adds `static const String notes = '/notes';` to `ApiPaths`
  (`lib/config/constants/api/api_paths.dart`), or tells you to if the file has changed shape;
- removes `domain/params/` and `data/data_sources/local/` when those options are off;
- runs `dart format` on the new feature.

## After generation

1. Add your fields to the entity, the model and (if present) the params/query.
2. `dart run build_runner build --delete-conflicting-outputs` — generates Freezed/JSON
   code and registers the data sources, repository and bloc with injectable.
3. Adjust the API contract documented at the top of the remote data source.
4. Build the page:
   ```dart
   BlocProvider(
     create: (_) => sl<NoteListBloc>(),
     child: Builder(
       builder: (context) => PaginationListView<Note>(
         bloc: context.read<NoteListBloc>(),
         itemBuilder: (context, note, _) => ListTile(title: Text(note.title)),
       ),
     ),
   );
   ```
   Search: `bloc.add(PagedListQueryChanged(NoteQuery(search: text)))` (debounced).
   Show `state.failure?.message.tr()` in a snackbar when items are already visible.
5. Add the route and translations for any new strings.

## Conventions baked in

- Data sources **throw** `AppException`s; repositories convert them once with `guard()`.
- No `Map<String, dynamic>` crosses the domain boundary; ids are `String`.
- Blocs never translate: they expose `Failure.message` (a localization key).
- Pagination supports page numbers **and** cursors (`PageRequest.cursor` ←
  `PageResult.nextCursor`).

## Verifying the brick

```bash
mason make flutter_feature -c config.json -o .   # from a checkout of the template
dart run build_runner build --delete-conflicting-outputs
flutter analyze lib/features/note                # expect: No issues found
rm -rf lib/features/note && git checkout lib/config/constants/api/api_paths.dart
```
