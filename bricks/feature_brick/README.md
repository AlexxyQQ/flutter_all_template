# flutter_feature brick

Generates a complete clean-architecture feature module for the `flutter_all_template` project.

## Usage

Run from the **project root** (next to `lib/`):

```bash
mason make flutter_feature
```

Answer the three prompts:

| Prompt | Description | Default |
|--------|-------------|---------|
| `feature_name` | Feature name in `snake_case` | `my_feature` |
| `use_local_datasource` | Add a `SecureStorage`-backed local data source alongside the remote | `false` |
| `use_params` | Generate a typed `RequestParams` class for create/update operations | `true` |

## What gets generated

```
lib/features/<feature_name>/
├── data/
│   ├── data_sources/
│   │   ├── <feature_name>_data_source.dart         # abstract interface
│   │   ├── remote/
│   │   │   └── <feature_name>_remote_data_source.dart
│   │   └── local/                                  # only if use_local_datasource
│   │       └── <feature_name>_local_data_source.dart
│   ├── models/
│   │   └── <feature_name>_model.dart               # Freezed + JSON, with toEntity()
│   └── repositories/
│       └── <feature_name>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── <feature_name>_entity.dart              # pure Freezed entity
│   │   └── params/                                 # only if use_params
│   │       └── <feature_name>_request_params.dart
│   └── repositories/
│       └── <feature_name>_repository.dart          # abstract interface
└── presentation/
    └── bloc/
        └── <feature_name>_bloc.dart
```

## After generation

1. **Add fields** to `_entity.dart`, `_model.dart`, and (if present) `_request_params.dart`. Run `rps build` to regenerate Freezed/JSON code.
2. **Add an API path** constant in `lib/config/constants/api/api_paths.dart`:
   ```dart
   static const String myFeature = '/my-feature';
   ```
3. **Register the repository** with `@lazySingleton` — it is already annotated; run `rps build` to update `service_locator.config.dart`.
4. **Register routes** in `lib/core/common/presentation/routes/app_router.dart` when you add screens.
5. Run `rps build` once more to pick up all generated code.

## Notes

- `use_params = false`: create/update operations accept `Map<String, dynamic>` instead of a typed params class. Use this for simple features or when you don't need a dedicated request model.
- `use_local_datasource = true`: the repository impl gets both `_localDataSource` and `_remoteDataSource` injected. Wire the read/write split in `_repository_impl.dart` as needed.
- The generated entity and model contain only an `id` field as a scaffold. Add your domain fields before running `rps build`.
