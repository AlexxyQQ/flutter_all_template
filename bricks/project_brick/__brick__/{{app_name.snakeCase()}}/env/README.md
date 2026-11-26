# `env/` — compile-time configuration

Each flavor reads one JSON file through `--dart-define-from-file`:

```bash
cp env/dev.example.json env/dev.json   # repeat for staging / prod
flutter run --dart-define-from-file=env/dev.json   # or: rps run dev
```

- `env/*.example.json` are tracked templates with **placeholder values only**.
- `env/<flavor>.json` are git-ignored; CI writes them from repository secrets/variables.
- Values are compiled into the app binary and can be extracted by anyone who has the
  app. **Never put secrets here** (private API keys, signing keys, passwords, server keys).

| Key | Type | Purpose |
|---|---|---|
| `FLAVOR` | string | `dev`, `staging` or `prod` |
| `BASE_URL` | string | API base URL (`https://…`, trailing slash) |
| `ENABLE_LOG_UPLOAD` | bool | Opt-in remote log upload (default `false`) |
| `LOG_UPLOAD_URL` | string | Endpoint for log upload when enabled |
| `ANALYTICS_ENABLED` | bool | Analytics master switch (default `false`); see `lib/core/common/domain/services/analytics/README.md` |
| `ANALYTICS_API_URL` | string | Absolute URL of a custom analytics batch endpoint (empty = not used) |
| `ANALYTICS_FIREBASE_ENABLED` | bool | Also send analytics to Firebase (Firebase builds only) |
| `DEV_PROXY` | string | `host:port` of a debugging proxy — **ignored in release builds** |
| `DEV_TRUST_SELF_SIGNED_CERTS` | bool | Accept self-signed certs — **ignored in release builds** |

The Dart side is `lib/config/env/app_env.dart`. See `docs/FLAVORS.md`.
