# Security policy

## Reporting a vulnerability

Please **do not open a public issue** for security problems. Report privately through
GitHub → **Security → Report a vulnerability** (private vulnerability reporting) on this
repository. Include the affected file/commit, impact, and reproduction steps.
We aim to acknowledge reports within 5 working days and to publish a fix or mitigation
as soon as it is verified. Apps generated from this template should replace this section
with their own contact and disclosure policy.

---

## What must never be in the client

A mobile app binary is public: anything compiled into it — Dart constants,
`--dart-define` values, assets, `google-services.json`, native resources — can be
extracted. Therefore the app must **never** contain:

- private API keys or secret keys of third-party services (payment, email, AI, maps
  server keys, …) — call them from your backend;
- FCM server keys / service-account JSON, Firebase Admin credentials;
- signing keys, keystores, certificates, or their passwords;
- database credentials, cloud provider credentials, webhook secrets;
- "admin" or debug back doors, feature flags that unlock privileged endpoints.

Public client identifiers (Firebase client config, OAuth client IDs, publishable keys) may
ship in the app, **but must be restricted**: API keys by Android package + SHA cert and iOS
bundle ID, Firebase protected with **App Check** and security rules.

---

## Secret handling in this repository

| What | Where it lives | Tracked? |
|---|---|---|
| Per-flavor public config | `env/<flavor>.json` (from `env/*.example.json`) | ❌ ignored (`*.example.json` tracked with placeholders) |
| Firebase client config | `google-services.json`, `GoogleService-Info.plist`, `firebase.json`, `firebase_options.dart` | ✅ placeholders only — real values come from `flutterfire configure` locally/CI and must not be committed |
| Android signing | `android/key.properties`, `*.jks` | ❌ ignored — see [`docs/CODE_SIGNING.md`](docs/CODE_SIGNING.md) |
| CI secrets | GitHub Actions secrets / environments | n/a |

Guards:

- **gitleaks** runs in CI over the full git history (`.gitleaks.toml` allowlists only the
  `YOUR_*` / `CHANGE_ME` placeholders). Run it locally before pushing:
  `gitleaks detect --config .gitleaks.toml` or `gitleaks protect --staged`.
- **OSV-Scanner** checks `pubspec.lock` for known-vulnerable dependencies; Dependabot keeps
  pub, Gradle and Actions dependencies current. GitHub Actions are pinned to commit SHAs.
- Enable GitHub **secret scanning** and **push protection** in repository settings.

To keep local Firebase files from showing up as changes after `flutterfire configure`:
`git update-index --skip-worktree android/app/google-services.json ios/Runner/GoogleService-Info.plist lib/config/firebase/firebase_options.dart firebase.json`.

---

## If a secret leaks (key rotation)

Assume any secret that reached a commit, PR, CI log, screenshot or chat is compromised —
even if the commit was "deleted".

1. **Revoke/rotate first.** Create a new credential, deploy it, then revoke the old one
   (Google Cloud Console → Credentials; Firebase → Project settings; provider dashboards).
   For Google API keys also add application + API restrictions to the new key.
2. **Check for abuse.** Review billing, quota and audit logs for the exposure window.
3. **Remove from the tree** in a normal commit.
4. **Purge history** (optional once rotated, required for public repos):
   `git filter-repo --replace-text replacements.txt` from a fresh mirror clone, where
   `replacements.txt` lives *outside* the repo; then force-push all branches/tags, ask every
   collaborator to re-clone, and ask GitHub support to purge cached views if needed.
5. **Verify:** `gitleaks detect --log-opts="--all"` reports nothing.
6. Record the incident (what, when, who rotated) outside the repo.

Owner actions still outstanding for this repository are tracked as **MANUAL** items in
[`TODO.md`](TODO.md) §0.

---

## Logging & redaction policy

Logs are written to the console in debug builds and may be persisted to files and
(opt-in, `ENABLE_LOG_UPLOAD=true`) uploaded. Therefore:

- **Never log:** access/refresh tokens, `Authorization`/`Cookie` headers, passwords, OTPs,
  push (FCM/APNs) tokens, secure-storage values, full request/response bodies of auth
  endpoints, route arguments, personal data (emails, phone numbers, addresses, location).
- Log **keys, ids and outcomes**, not values: `"secure storage write: key=auth_tokens ok"`.
- Network logging must redact sensitive headers and body fields before printing.
- Release builds log warnings/errors only, and error reports must be sanitized
  (no raw exception text that may embed request data).
- Remote log upload is **off by default**, must use HTTPS, must not reuse the API client
  that attaches bearer tokens, and should send sanitized error events only.
- Use `AppLogger`; `print`/`debugPrint` are not allowed in `lib/`.

---

## Platform hardening defaults

- Android release: real signing key required for publishing, R8 + resource shrinking,
  Dart obfuscation (`--obfuscate --split-debug-info`), `allowBackup="false"` with
  exclude-all extraction rules, cleartext HTTP disabled (debug-only exception for
  emulator/localhost), no user-installed CAs trusted in release.
- iOS: ATS at its strict default, minimal background modes, only purpose strings for
  features the app uses.
- TLS bypass and proxy settings (`DEV_TRUST_SELF_SIGNED_CERTS`, `DEV_PROXY`) are honoured in
  debug builds only.
- Push payloads may only navigate to allowlisted routes; never navigate to arbitrary
  strings from notifications or deep links.

See [`docs/PLATFORM_SETUP.md`](docs/PLATFORM_SETUP.md) for details.
