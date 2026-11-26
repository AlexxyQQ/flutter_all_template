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
└── presentation/
    ├── bloc/      note_list_bloc.dart, note_list_event.dart
    ├── routes/    note_route.dart              NoteRoutes.path = '/notes' + NoteRoutes.route
    └── views/
        ├── wrappers/  note_wrapper.dart        NoteWrapperRoute: provides NoteListBloc (loads page 1)
        ├── screens/   note_list_screen.dart    NoteRoute: app bar, add button, list
        └── widgets/note_list/  note_body_widget.dart, note_tile_widget.dart, add_note_dialog_widget.dart
test/widget/features/note/note_flow_test.dart   route, wrapper bloc, empty, error + retry, add, delete
```

The post-gen hook also, idempotently (running it twice never duplicates anything):

- adds `ApiPaths.notes = '/notes'` to `lib/config/constants/api/api_paths.dart`;
- registers `NoteRoutes.route` (and its import) in `lib/core/common/presentation/routes/app_router.dart`;
- adds `features.note.presentation.screens.note_list_screen.{title,add,hint}` to
  `assets/translations/en-GB.json` (translate
  `ne-NP` yourself; existing keys are never overwritten);
- points the widget test at your package (`name:` in `pubspec.yaml`);
- removes the folders of disabled options and formats the result.

If an anchor is missing (a file was restructured) the hook prints what to add by hand.

## After generation

1. Add your fields to the entity, model and params (and show them in `note_tile_widget.dart`).
2. `dart run build_runner build --delete-conflicting-outputs` (Freezed, JSON, injectable
   registration and the auto_route routes).
3. `dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart`
   (the screen uses the new `LocaleKeys.features_note_*` constants).
4. Adapt the API contract documented at the top of the remote data source.
5. Open the page with `context.router.push(const NoteRoute())` (or add a button on the home
   screen), then run `flutter test`: the generated widget test already covers the page.

Presentation depends on the use cases (one class per action, named parameters, thin
forwarders to the repository interface; `CreateNoteUseCase` trims the title), never on the
repository or data sources.

Data sources throw `AppException`s, repositories convert them once with `guard()`, and
blocs never translate (they expose `Failure.message`, a localization key).
