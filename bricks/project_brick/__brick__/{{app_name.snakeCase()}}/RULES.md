# Code Rules

The rules every contributor follows. Each rule has a short reason and a
**Do** / **Don't** example. The best working reference is the
[`lib/features/example`](lib/features/example) feature (the to-do list) — when in doubt, copy its shape.

Quick index: [Architecture](#1-architecture) · [Named parameters & constructors](#2-named-parameters-only-methods-and-constructors) ·
[Errors](#3-errors) · [State (BLoC)](#4-state-bloc) · [DI](#5-dependency-injection) ·
[UI](#6-ui) · [Strings](#7-strings--localization) · [Imports & style](#8-imports--style) ·
[Logging](#9-logging) · [Config & secrets](#10-config--secrets) · [Tests](#11-tests) ·
[Generated code](#12-generated-code) · [Git & releases](#13-git--releases)

---

## 1. Architecture

Every feature is `data` → `domain` ← `presentation`. Dependencies point **inward** to `domain`.

```
features/<name>/
├── data/          models, data_sources/{remote,local}, repositories (impl)
├── domain/        entities, params, repository interfaces, usecases   (pure Dart)
└── presentation/  bloc/, routes/, views/{wrappers,screens,widgets}/   (a wrapper route provides the bloc)
```

Shared code lives in `core/`, which never imports `features/` or `app/`:

```
core/<area>/                 error, network, storage, session, generic, presentation (modals)
core/services/<name>/        domain/        interfaces + entities (pure Dart)
                             data/          implementations, DI modules, helpers (Dio, Hive, Firebase, plugins)
                             presentation/  only when the service touches Flutter UI (observers, NavigationService)
app/                         composition root: bootstrap, DI, router, observers, global providers
```

`app/` is the only place that knows every feature (the router composes feature routes).
Feature route files import the generated route classes from `app/router/app_router.gr.dart`.

| Layer | May import | Must NOT import |
|---|---|---|
| `domain` | Dart, `equatable`, `freezed_annotation`, `fpdart`, `injectable` (annotations only) | Flutter, Dio, Hive, Firebase, auto_route, plugins, JSON, other layers |
| `data` | `domain`, `core/network`, `core/storage` | `presentation`, Flutter widgets |
| `presentation` | `domain`, `core/*`, Flutter | `data` (talk to **use cases**, not repositories) |

✅ **Do** — bloc depends on use cases:

```dart
class TodoListBloc extends PagedListBloc<Todo, TodoQuery> {
  TodoListBloc({
    required GetTodosUseCase getTodos,
    required DeleteTodoUseCase deleteTodo,   // domain use case
  }) : _deleteTodo = deleteTodo, super(...);

  final DeleteTodoUseCase _deleteTodo;
}
```

❌ **Don't** — presentation reaching into data:

```dart
import '../../data/data_sources/remote/todo_remote_data_source.dart'; // ✗
final todos = await TodoRemoteDataSource(dio).getTodos(...);          // ✗
```

- Presentation → **use cases** → repository interface (implemented in `data`).
- Entities are plain domain objects (no `fromJson`). JSON lives in `data/models`
  and converts with `toEntity()`.
- Add a feature with the Mason `feature_brick` (see the README) instead of copy-pasting folders.
- Shared code goes in `core/`; code used by one feature stays in that feature.

### Use cases

One class per business action in `domain/usecases/<action>_use_case.dart`: pure Dart,
depends only on the repository interface, `@lazySingleton`, invoked like a function.
Parameters are named and `required`. Keep them thin: forward to the repository unless
there is real business logic (e.g. `CreateTodoUseCase` trims the title). They do not
catch errors: the repository's `guard()` already returns `Either<Failure, T>`.

✅ **Do**

```dart
@lazySingleton
class DeleteTodoUseCase {
  const DeleteTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;

  ResultFuture<void> call({required String id}) =>
      _repository.deleteTodo(id: id);
}

final result = await _deleteTodo(id: id);   // in the bloc: DeleteTodoUseCase deleteTodo
```

❌ **Don't**

```dart
class TodoListBloc { TodoListBloc({required ITodoRepository repository}); }        // ✗ repository, not a use case
class TodoListBloc { TodoListBloc({required TodoRemoteDataSource remote}); }       // ✗ data source in presentation
```

---

## 2. Named parameters only (methods and constructors)

Use-case, repository, data-source and service methods take **named, `required`** parameters. Never positional.
Call sites then read clearly and adding a parameter never breaks argument order.

✅ **Do**

```dart
abstract interface class ITodoRepository {
  ResultFuture<Todo> getTodo({required String id});
  ResultFuture<Todo> createTodo({required CreateTodoParams params});
  ResultFuture<void> deleteTodo({required String id});
}

final result = await _deleteTodo(id: event.id);
```

❌ **Don't**

```dart
ResultFuture<Todo> getTodo(String id);                 // ✗ positional
final result = await _deleteTodo(event.id);              // ✗ what is event.id?
```

- Required named parameters come **before** optional ones (lint: `always_put_required_named_parameters_first`).
- More than one value that travels together → a `Params` class in `domain/params/`
  (`CreateTodoParams`), not a long parameter list.
- Mocks follow the same shape: `when(() => getTodo(id: any(named: 'id')))` (mock the use case class and stub `call`).

### Constructors and dependencies

Classes that receive collaborators (repositories, data sources, use cases, blocs/cubits,
services, interceptors, stores, clients) take them as **named, `required`, public** parameters,
never as positional ones. Call sites self-document (`TodoRepositoryImpl(remote: r, local: l)`),
DI and tests do not depend on argument order, and adding a dependency never silently reorders
existing arguments. Keep the fields private by assigning them in the initializer list.

✅ **Do**

```dart
class TodoRepositoryImpl implements ITodoRepository {
  TodoRepositoryImpl({
    required ITodoRemoteDataSource remote,
    required ITodoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;
}

// bloc / use case: same shape; `super.` params stay named too
@injectable
class TodoListBloc extends PagedListBloc<Todo, TodoQuery> {
  TodoListBloc({
    required GetTodosUseCase getTodos,
    required DeleteTodoUseCase deleteTodo,
    @ignoreParam super.queryDebounce,
  }) : _deleteTodo = deleteTodo,
       super(
         initialQuery: const TodoQuery(),
         fetchPage: (page, query) => getTodos(page: page, query: query),
       );

  final DeleteTodoUseCase _deleteTodo;
}

@lazySingleton
class DeleteTodoUseCase {
  const DeleteTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;
}
```

❌ **Don't**

```dart
class TodoRepositoryImpl implements ITodoRepository {
  TodoRepositoryImpl(this._remote, this._local);   // ✗ positional: which is which?
  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;
}

final repo = TodoRepositoryImpl(local, remote);    // ✗ swapped silently if the types allow it
```

- `const` constructors stay `const`; required named parameters come before optional ones.
- injectable passes named constructor parameters by name, so `@injectable` / `@lazySingleton`
  classes work unchanged; keep `@ignoreParam`, `@factoryParam` and `@Named(...)` on the (named) parameter.
- Exceptions: widgets (`const Foo({super.key, required ...})` is already named), and plain data
  classes: entities, models, params, `Failure`, exceptions, events and states (e.g. `TodoDeleted(this.id)`).

---

## 3. Errors

Exceptions stay in the **data** layer. The domain and UI only ever see a `Failure` inside an `Either`.

```
data source  throws AppException  →  repository wraps in guard()  →  Either<Failure, T>  →  bloc folds it
```

✅ **Do** — wrap every data-source call with `guard()`; it is the only place exceptions become failures:

```dart
@override
ResultFuture<Todo> getTodo({required String id}) =>
    guard(() async => (await _remote.getTodo(id: id)).toEntity());
```

✅ **Do** — fold the result in the bloc:

```dart
emit(result.fold(
  (failure) => state.copyWith(failure: () => failure),
  (todo) => state.copyWith(items: [todo, ...state.items]),
));
```

❌ **Don't**

```dart
try {
  final todo = await _remote.getTodo(id: id);       // ✗ try/catch in a repository
  return Right(todo.toEntity());
} catch (e) {
  return Left(Failure(messageKey: e.toString()));   // ✗ leaks raw exception text
}
```

- `Failure.messageKey` is **always** a localization key, never raw exception text, a stack trace, a URL or a token.
  `Failure.serverMessage` is the optional backend text that is safe to show verbatim. Widgets display
  `failure.displayText` (`core/presentation/failure_text.dart`), never `.tr()` on a failure field.
- Local data that belongs to the signed-in user goes in `IPreferencesStore` under `SessionScope.keyPrefix`
  (`'session.'`); sign-out and forced session expiry remove every such key, so no per-feature cleanup hook is needed.
- Throw `AppException` subclasses from data sources; never throw `String`s or bare `Exception`s.
- Don't swallow errors (`catch (_) {}`). If a failure is genuinely ignorable (e.g. a cache write),
  say why in a comment.

---

## 4. State (BLoC)

- Events and states are `Equatable`, immutable, and `final class`.
- A bloc handles **one** feature. Use `sequential()` for mutations that must not interleave,
  `restartable()` for search-as-you-type.
- Never call `emit` after an `await` without the handler still being active (use the `Emitter` passed in).
- Blocs call **use cases**, never repositories, data sources, Dio or `SharedPreferences`.

✅ **Do**

```dart
final class TodoDeleted extends PagedListEvent {
  const TodoDeleted(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
```

❌ **Don't**

```dart
class TodoDeleted { String id; TodoDeleted(this.id); }   // ✗ mutable, no equality
```

- Reuse `PagedListBloc` from `core/generic` before writing a new one.
- UI never holds business state in `setState` beyond purely visual state (focus, animation, form text).

---

## 5. Dependency injection

`get_it` + `injectable`. Register **interfaces**, resolve them in constructors, and use the locator
(`sl`) only at the edges (screen `BlocProvider.create`, `bootstrap`).

✅ **Do**

```dart
@LazySingleton(as: ITodoRepository)
class TodoRepositoryImpl implements ITodoRepository {
  TodoRepositoryImpl({
    required ITodoRemoteDataSource remote,
    required ITodoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;
}
```

❌ **Don't**

```dart
class TodoRepositoryImpl {
  final _remote = sl<TodoRemoteDataSource>();   // ✗ service locator inside a class
  final dio = Dio();                            // ✗ creating infrastructure by hand
}
```

- Blocs: `@injectable` (new instance per screen). Use cases, repositories and data sources: `@LazySingleton`.
- Don't call `sl<...>()` from `build` methods of widgets other than a `BlocProvider.create`.
- After adding/removing an annotation run `rps gen`.

---

## 6. UI

The template uses **Material 3 with the default `ThemeData`**. Build screens from Flutter's
widgets and use `ModalService` with `AppPopupDialog` or `AppBottomSheet` for shared modal layouts.
Keep product-specific design systems in the app.

✅ **Do**

```dart
FloatingActionButton(
  key: const Key('todo_add_button'),
  tooltip: LocaleKeys.features_example_add.tr(),
  onPressed: () => _addTodo(context),
  child: const Icon(Icons.add),
)
```

❌ **Don't**

```dart
Container(color: Color(0xFF3A86FF), child: Text('Add'))   // ✗ hard-coded colour + string
Theme(data: ThemeData(...), child: ...)                    // ✗ per-screen theming
```

- Colours/typography come from `Theme.of(context)`; never hard-code hex values in widgets.
- Use `const` constructors wherever possible. Extract parts of a large `build` method into
  public widgets in their own files.
- Every screen has a loading, empty and error state. Errors show a retry action.
- **Test ids:** every interactive widget the E2E flows touch gets **both** a `Key('<screen>_<thing>')`
  and `Semantics(identifier: '<screen>_<thing>')` (Maestro matches the semantics id). See
  [`docs/MAESTRO.md`](docs/MAESTRO.md).

```dart
Semantics(
  identifier: 'todo_add_button',
  child: FloatingActionButton(key: const Key('todo_add_button'), ...),
)
```

- Screens are `@RoutePage` classes in `presentation/views/screens/`; route definitions live in
  `presentation/routes/<feature>_routes.dart` as one `<Feature>Routes` holder with `static final route`
  (and `path`), registered in `app/router/app_router.dart`. Generated route names drop the
  `Screen` / `Page` / `Wrapper` suffix (`TodoListScreen` → `TodoListRoute`, `TodoWrapper` → `TodoRoute`). Navigate between screens through the auto_route router /
  `NavigationService`, never `Navigator.push` with a raw `MaterialPageRoute`. (`Navigator.pop` to close
  a dialog is fine.)

---

## 7. Strings & localization

No user-visible text in code. Add keys to `assets/translations/en-GB.json` (and `ne-NP.json`),
run `rps gen:keys`, and use `LocaleKeys`.

✅ **Do**

```dart
Text(LocaleKeys.common_errors_somethingWentWrong.tr())
```

❌ **Don't**

```dart
Text('Something went wrong')              // ✗ hard-coded (also flagged by custom_lint)
Text(failure.messageKey)                  // ✗ shows the key; use failure.displayText
```

- Keys are **semantic**, never a mirror of a file path: `common.*` for shared text and
  `features.<name>.<key>` for one feature (`features.home.title`). Moving a file must not rename a key.
- Delete keys when you delete the UI that used them.

---

## 8. Imports & style

`dart format`, `flutter analyze` and `custom_lint` must be clean — CI enforces it. Highlights from
[`analysis_options.yaml`](analysis_options.yaml):

| Rule | Do | Don't |
|---|---|---|
| Relative imports inside `lib/` | `import '../../domain/entities/todo.dart';` | `import 'package:my_app/features/...';` |
| Single quotes | `'hello'` | `"hello"` |
| Trailing commas on multi-line calls | `foo(\n  a,\n  b,\n);` | `foo(\n  a,\n  b);` |
| `final` locals | `final name = 'x';` | `var name = 'x';` |
| `const` where possible | `const SizedBox(height: 8)` | `SizedBox(height: 8)` |
| Explicit return types | `Future<void> load() async {}` | `load() async {}` |
| No `void async` | `Future<void> save() async {}` | `void save() async {}` |
| Handle futures | `await save();` or `unawaited(save());` | `save();` (floating future) |
| Constructors first in a class | constructor, fields, methods | methods before the constructor |

- Types are explicit where inference would be `dynamic` (`strict-casts`, `strict-inference`, `strict-raw-types`
  are on): `List<String>`, not `List`.
- Files are `snake_case.dart`; classes `UpperCamelCase`; **every** abstract interface is prefixed `I`
  (`ITodoRepository`, `ISessionManager`, `IApiClient`, `ISecureStore`). Widget files drop a `_widget`
  suffix (`todo_tile.dart` → `TodoTile`). Use `ResultFuture<void>` for "no value" results.
- Declare at most one class or interface per hand-written Dart file. Split
  implementations, models, events, states, and widgets into their own files. Use Dart library
  parts when related sealed types must share a library.
- Declare classes public. A `StatefulWidget` may keep its own private `State` subclass in the
  widget file. Private methods and fields are allowed.
- Declare no top-level variables or constants. Own state in an instance and inject that
  instance where it is used. Put shared constants on the class that owns the value.
- Declare functions as instance or static methods on the class that owns the behavior.
  Keep runtime-required entry points such as Dart's `main` thin and delegate their
  work to a class.
- Comments explain **why**, not what. Public interfaces get a one-line `///` doc.

---

## 9. Logging

Never `print` (lint: `avoid_print`). Use `AppLogger` (or an injected `ILoggerService`). The logger
redacts secrets before anything reaches a sink.

✅ **Do**

```dart
AppLogger.error('Sync failed', error: e, stackTrace: s, name: 'Sync');
```

❌ **Don't**

```dart
print('token = $token');                // ✗ print, and logs a secret
debugPrint(response.headers.toString()) // ✗ may contain Authorization
```

---

## 10. Config & secrets

- Config is compile-time: `--dart-define-from-file=env/<flavor>.json`, read through `AppEnv`.
  No `.env` files, no `flutter_dotenv`.
- `env/*.example.json` is committed; real `env/dev|staging|prod.json` are git-ignored.
- Real Firebase config is git-ignored; copy it from the `*.example` files with `rps firebase:init`.
- **Never commit:** keystores, `android/key.properties`, real `google-services.json` /
  `GoogleService-Info.plist`, API keys, tokens. See [`SECURITY.md`](SECURITY.md).
- Tokens go in `ISecureStore`; non-secret settings in `IPreferencesStore`. Never put a token in
  `SharedPreferences`.
- Use `EncryptedHiveStore` for sensitive local records such as diagnostic events. Keep
  signing keys, tokens, and the store's encryption keys in platform secure storage.

✅ **Do** — `AppEnv.baseUrl`  ·  ❌ **Don't** — `const apiKey = 'sk-live-…';`

---

## 11. Tests

Tests mirror `lib/` under `test/unit` and `test/widget`. A PR that adds behaviour adds a test.

| What | Where | How |
|---|---|---|
| Repository / data source | `test/unit/features/<name>/data` | fake HTTP adapter, in-memory stores |
| Use case | `test/unit/features/<name>/domain/usecases` | mocked repository; check forwarding and any logic |
| Bloc | `test/unit/features/<name>/presentation` | `bloc_test`, mocked use cases |
| Screen flow | `test/widget/...` | pump the screen with a mocked bloc/use cases |
| Whole app | `.maestro/flows` | real device/emulator, run locally ([MAESTRO.md](docs/MAESTRO.md)) |

✅ **Do** — test behaviour, one assertion topic per test, descriptive names:

```dart
test('falls back to the cache when offline', () async { ... });
```

❌ **Don't** — hit the real network, depend on test order, or assert on private state.

Run everything CI runs with `rps check` before pushing.

---

## 12. Generated code

`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart` and `lib/config/constants/gen/` are
**git-ignored**. Never edit or commit them; run `rps gen` after pulling or changing an annotated
class, route, asset or translation.

---

## 13. Git & releases

- Branch from `main`, keep PRs small and focused, one concern per PR.
- Commit messages: [Conventional Commits](https://www.conventionalcommits.org) —
  `feat(todo): add search`, `fix(network): retry on 502`, `chore: bump deps`.
- Before pushing: `rps check` (format, analyze, test).
- The Mason project brick (`bricks/project_brick/__brick__`) is generated and git-ignored: run
  `rps brick` before `mason make`; never edit or commit it. CI runs the generator as a smoke test.
- **CI is deliberately cheap** (Linux-only, PRs and pushes to `main`). Don't add macOS runners, emulators, or release builds
  to GitHub Actions. Releases are built locally with `scripts/release.sh`, iOS via the manual Codemagic
  workflow. Details: [`docs/CI_CD.md`](docs/CI_CD.md).
- User-visible changes get a line in `CHANGELOG.md` (template repo).

---

### Quick PR checklist

- [ ] Layers respected (no `data` imports in `presentation`, no Flutter in `domain`)
- [ ] Blocs depend on use cases (one class per action), not repositories
- [ ] Use-case / repository / data-source parameters are **named**
- [ ] Dependencies are injected through **named, `required`** constructor parameters (private fields set in the initializer list)
- [ ] Errors go through `guard()` → `Failure`; nothing swallowed
- [ ] No hard-coded strings, colours or secrets
- [ ] One class per file, no private helper classes, and no top-level variables or helper functions
- [ ] New interactive widgets have `Key` + `Semantics(identifier: ...)` when E2E-relevant
- [ ] Tests added/updated; `rps check` passes
- [ ] `rps gen` run if annotations, routes or translations changed
