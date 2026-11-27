# flutter_feature brick

Generates a clean-architecture feature slice (paged list, with optional search, create,
update and delete) for a project made from this template. It is built on
`lib/core/generic/` (`PagedListBloc`, `PageRequest`/`PageResult`, `JsonCollectionStore`)
and follows the layering of the reference slice in `lib/features/example/` (Todos).

## Usage

Run from the project root (next to `lib/`):

```bash
mason get
mason make flutter_feature
```

Every prompt has a default, so pressing Enter through all of them gives the full slice.

### Naming

| Variable | Meaning | Default |
|---|---|---|
| `feature_name` | Singular name in any case (`note`, `user_profile`) | `note` |
| `feature_plural` | Plural used for list names (`getNotes`, `ApiPaths.notes`). Empty derives it (`note` → `notes`, `category` → `categories`, `address` → `addresses`). Irregular plurals (`person` → `people`) need an explicit value | derived |
| `api_path` | Collection path **relative to the base URL**, no leading slash (like every `ApiPaths` entry), e.g. `v1/notes` | `<plural-in-kebab-case>` |
| `route_path` | In-app / deep-link path of the page, e.g. `/my-notes` | `/<plural-in-kebab-case>` |

The plural must differ from the singular (`news` → pass `feature_plural: news_items`),
otherwise `getNews()` and `getNews({id})` would clash; the hook refuses it.

### What to generate

| Variable | Meaning | Default |
|---|---|---|
| `include_create` | Create use case, repository/data-source methods, `…Created` event, add button and dialog | `true` |
| `include_update` | Update use case, repository/data-source methods and an `…Updated` event on the bloc (no screen: wire your own edit UI) | `true` |
| `include_delete` | Delete use case, repository/data-source methods, `…Deleted` event and the delete button on each tile | `true` |
| `include_search` | Search field under the app bar, wired to the list's debounced query | `true` |
| `use_local_datasource` | Offline cache: reads are cached and served when offline | `false` |
| `use_params` | Typed `Create/Update…Params` and `…Query` classes (off: plain arguments and a `String` query) | `true` |

Turning an operation off removes its files, methods, events, UI and test, so a read-only
list is just `include_create/update/delete: false`. Reading (list + by id) is always generated.

### What the post-gen hook edits for you

| Variable | Meaning | Default |
|---|---|---|
| `generate_tests` | Generate `test/widget/features/<name>/<name>_flow_test.dart` | `true` |
| `register_api_path` | Add the constant to `lib/config/constants/api/api_paths.dart` | `true` |
| `register_route` | Register `…Routes.route` (and its import) in `lib/app/router/app_router.dart` | `true` |
| `add_translations` | Add `features.<name>.{title,add,hint}` to `assets/translations/en-GB.json` | `true` |
| `format_code` | Run `dart format` on the generated files | `true` |

Set any of these to `false` to wire that part up yourself; the hook then prints exactly what to
add. All edits are idempotent (running it twice never duplicates anything) and existing
translation keys are never overwritten.

Non-interactive: `mason make flutter_feature -c config.json`, for example

```json
{
  "feature_name": "category",
  "feature_plural": "",
  "api_path": "v1/categories",
  "route_path": "",
  "include_create": true,
  "include_update": false,
  "include_delete": true,
  "include_search": true,
  "use_local_datasource": true,
  "use_params": true
}
```

Variables you leave out of a config file get their default only in interactive runs; pass the
ones you care about and keep the full list (see `brick.yaml`) for CI use.

## Output (`feature_name: note`, everything on)

```
lib/features/note/
├── domain/        entities/note.dart, params/note_params.dart (use_params), usecases/ (list + enabled create/update/delete), repositories/
├── data/          models/, data_sources/remote/, data_sources/local/ (use_local_datasource), repositories/
└── presentation/
    ├── bloc/      note_list_bloc.dart, note_list_event.dart
    ├── routes/    note_routes.dart             NoteRoutes.path = '/notes' + NoteRoutes.route
    └── views/
        ├── wrappers/  note_wrapper.dart        NoteRoute (generated): provides NoteListBloc (loads page 1)
        ├── screens/   note_list_screen.dart    NoteListRoute (generated): app bar, search, add button, list
        └── widgets/note_list/  note_body.dart, note_tile.dart, add_note_dialog.dart (create), note_search_field.dart (search)
test/widget/features/note/note_flow_test.dart   route, wrapper bloc, empty, error + retry, search, add, update, delete
```

## After generation

1. Add your fields to the entity, model and params (and show them in `note_tile.dart`).
2. `dart run build_runner build --delete-conflicting-outputs` (JSON serialization, injectable
   registration and the auto_route routes).
3. `dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart`
   (the screen uses the new `LocaleKeys.features_note_*` constants).
4. Translate the keys in the other `assets/translations/*.json` files.
5. Adapt the API contract documented at the top of the remote data source.
6. Open the page with `context.router.push(const NoteRoute())` (or add a button on the home
   screen), then run `flutter test`: the generated widget test already covers the page.

Presentation depends on the use cases (one class per action, named parameters, thin
forwarders to the repository interface; `CreateNoteUseCase` trims the title), never on the
repository or data sources.

Data sources throw `AppException`s, repositories convert them once with `guard()`, and
blocs never translate (they expose the `Failure`; widgets show `failure.displayText`).

## Maintaining the brick

Optional files are named `{{{<something>_path}}}` and `hooks/pre_gen.dart` sets each variable
to the real path (enabled) or `''` (disabled), because Mason skips templates whose rendered path
is empty. Optional regions inside files use Mustache sections on the `include_*` / `use_*`
variables; `has_mutations` and `mutations_label` are derived by the hook. When you add a variable,
declare it in `brick.yaml`, derive anything computed in `pre_gen.dart`, and cover the on/off
combinations by generating into a scratch copy of the project and running `flutter analyze` and
`flutter test`.
