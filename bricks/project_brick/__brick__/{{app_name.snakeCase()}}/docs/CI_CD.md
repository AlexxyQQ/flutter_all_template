# CI/CD

## Philosophy

**Build locally, upload to GitHub. Codemagic only for iOS, started by hand.**
GitHub Actions only runs a cheap Linux quality check on pull requests and on pushes to `main`. It never builds an
app, never runs an emulator or Maestro, and never uses macOS runners (10x minute cost).

## What runs where

| What | Where | Trigger | Cost |
|---|---|---|---|
| Format, analyze, custom_lint, tests, brick generation smoke test | GitHub Actions, Linux (`ci.yml`) | pull request or push to `main` touching code; manual | about 5-8 min per run |
| OSV dependency scan | GitHub Actions, Linux (`security.yml`) | weekly + manual | about 1 min per run |
| Dependency updates | Dependabot | monthly, grouped (4 PRs max) | triggers `ci.yml` a few times a month |
| Android APK / AAB | Your machine (`scripts/release.sh`) | you run it | 0 GitHub minutes |
| iOS IPA | Codemagic, `mac_mini_m2` (`codemagic.yaml`) | manual / API only | free tier: about 500 min/month, a build is about 10-20 min |
| Maestro / emulator tests | Your machine | you run them | 0 |

Estimated GitHub usage: about 15 PRs x 7 min + 4 scans = roughly 110-150 Linux min/month,
far below the 2,000 free. The old setup also ran a full-history gitleaks job, about 2-3x more.

Secret scanning: `gitleaks-action` was removed because it needs a paid license for
organization repos. Run `gitleaks detect --config .gitleaks.toml` locally or as a
pre-commit hook (`gitleaks protect --staged`), and enable GitHub secret scanning/push
protection in repo settings where available.

## Releasing Android (local)

One-time: create the keystore and `android/key.properties` (`docs/CODE_SIGNING.md`),
copy `env/<flavor>.example.json` to `env/<flavor>.json`, install and log in the GitHub CLI
(`gh auth login`).

1. Bump `version:` in `pubspec.yaml`, commit and **push** (the release tags that commit).
2. Preview: `bash scripts/release.sh prod --dry-run` (builds and uploads nothing).
3. Release: `bash scripts/release.sh prod` (add `--aab` for the Play Store bundle,
   `--notes "text"` for custom notes).

The script checks for a clean tree, `gh` login, `env/<flavor>.json`, the signing file and (with Firebase)
a real, non-placeholder `android/app/google-services.json` (PR CI uses the placeholders from
`scripts/firebase_init.sh`),
then runs `pub get`, code generation and an obfuscated release build, and creates (or
updates) the GitHub Release `v<version>` (`v<version>-<flavor>` and pre-release for dev
and staging). Assets: `<app>-<version>-<flavor>.apk` / `.aab` and
`...-symbols.tar.gz` (Dart symbols and R8 `mapping.txt`, keep them to read crash traces).
It works in Git Bash on Windows, macOS and Linux.

## Releasing iOS (Codemagic)

One-time setup:

1. Create a Codemagic account, add this repo, choose "Use codemagic.yaml".
2. Teams > Integrations > App Store Connect: add an API key and name it `codemagic`
   (details in `docs/CODE_SIGNING.md`).
3. Environment variables > group `ios_release`:
   - `ENV_JSON_DEV`, `ENV_JSON_STAGING`, `ENV_JSON_PROD` (secure): the full content of
     each `env/<flavor>.json`;
   - `FIREBASE_IOS_PLIST_BASE64`, `FIREBASE_ANDROID_JSON_BASE64`, `FIREBASE_OPTIONS_DART_BASE64`
     (secure): `base64` of the real Firebase files (git-ignored). **Required for `FLAVOR=prod`**:
     the build fails when one is missing instead of shipping placeholder Firebase config. Other
     flavors fall back to the tracked `*.example` placeholders (`scripts/firebase_init.sh`);
   - optional `GITHUB_TOKEN` (secure, fine-grained token with Contents: read/write on this
     repo) and `GITHUB_REPO` (`owner/name`) to attach the IPA to the GitHub Release.
4. In `codemagic.yaml` set the `bundle_id` anchor (and `flutter:` if `.fvmrc` changes). `xcode:` is
   pinned; bump it deliberately. Every build runs `flutter analyze` and `flutter test` before building.

Run a build, either way:

- UI: Start new build > pick the workflow `ios-release` (artifact only) or `ios-testflight`
  (also submits to TestFlight); optionally set `FLAVOR`.
- API:

```bash
curl -X POST https://api.codemagic.io/builds \
  -H "Content-Type: application/json" -H "x-auth-token: $CODEMAGIC_API_TOKEN" \
  -d '{"appId":"<APP_ID>","workflowId":"ios-release","branch":"main",
       "environment":{"variables":{"FLAVOR":"prod"}}}'
```

Download the `.ipa` and `.dSYM.zip` from the build page. If you released Android first,
the IPA is also uploaded to the same GitHub Release (skipped when the secrets are unset
or the release does not exist).

## Keeping GitHub minutes low

- Do not add push triggers, matrix builds, macOS runners or release builds to workflows.
- Doc-only changes are skipped by `paths-ignore`; new pushes cancel older runs.
- Batch work into fewer, larger PRs; use draft PRs and run `rps check` locally first.
- Do not upload artifacts (storage counts against the quota).
- Check usage at GitHub > Settings > Billing > Usage.
