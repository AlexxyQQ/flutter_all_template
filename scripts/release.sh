#!/usr/bin/env bash
# Build Android release artifacts locally and upload them to a GitHub Release.
#
#   scripts/release.sh <dev|staging|prod> [--aab] [--dry-run] [--notes "text"]
#
# Nothing is built in GitHub Actions; this runs on your machine (Git Bash on
# Windows, macOS or Linux) and uses the `gh` CLI. See docs/CI_CD.md.
#
#   --aab       also build the Play Store app bundle
#   --dry-run   print every step, run nothing that builds, pushes or hits the network
#   --notes     release notes (default: GitHub auto-generated notes)
#
# Needs: flutter, dart, git, gh (logged in), tar, android/key.properties (see
# docs/CODE_SIGNING.md) and env/<flavor>.json (see env/README.md).
set -euo pipefail

usage() { sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-1}"; }

FLAVOR=""; AAB=0; DRY=0; NOTES=""
while [ $# -gt 0 ]; do
  case "$1" in
    dev|staging|prod) FLAVOR="$1" ;;
    --aab) AAB=1 ;;
    --dry-run) DRY=1 ;;
    --notes) shift; NOTES="${1:-}" ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown argument: $1" >&2; usage ;;
  esac
  shift
done
[ -n "$FLAVOR" ] || usage

cd "$(git rev-parse --show-toplevel)"

# Run a command, or only print it in dry-run mode.
run() {
  if [ "$DRY" = 1 ]; then echo "[dry-run] $*"; else echo "+ $*"; "$@"; fi
}
fail() { echo "ERROR: $*" >&2; exit 1; }
# In dry-run a failed check is only a warning, so the plan can still be printed.
check() { if [ "$DRY" = 1 ]; then echo "WARN: $*" >&2; else fail "$*"; fi; }

# --- Version and names ------------------------------------------------------
APP="$(sed -n 's/^name:[[:space:]]*//p' pubspec.yaml | head -n1 | tr -d '\r')"
FULL="$(sed -n 's/^version:[[:space:]]*//p' pubspec.yaml | head -n1 | tr -d '\r')"
VERSION="${FULL%%+*}"                     # 1.2.3+4 -> 1.2.3
[ -n "$APP" ] && [ -n "$VERSION" ] || fail "cannot read name/version from pubspec.yaml"

TAG="v$VERSION"; PRERELEASE=()
if [ "$FLAVOR" != "prod" ]; then TAG="$TAG-$FLAVOR"; PRERELEASE=(--prerelease); fi
ENV_FILE="env/$FLAVOR.json"
OUT="build/release"
BASE="$APP-$VERSION-$FLAVOR"
SYMBOLS_DIR="build/symbols/$FLAVOR"
echo "Releasing $APP $FULL ($FLAVOR) as $TAG"

# --- Safety checks ----------------------------------------------------------
[ -f "$ENV_FILE" ] || check "$ENV_FILE not found (copy env/$FLAVOR.example.json)"
[ -f android/key.properties ] || check "android/key.properties missing: the build would be signed with the DEBUG key (docs/CODE_SIGNING.md)"
[ -z "$(git status --porcelain)" ] || check "git working tree is not clean"
if grep -qE '^[[:space:]]+firebase_core:' pubspec.yaml; then
  # Firebase config is git-ignored; a placeholder would ship an app that cannot reach Firebase.
  if [ ! -f android/app/google-services.json ]; then
    check "android/app/google-services.json missing: run 'flutterfire configure' (see SECURITY.md)"
  elif grep -q 'YOUR_PROJECT_ID' android/app/google-services.json; then
    check "android/app/google-services.json is still the placeholder: run 'flutterfire configure'"
  fi
  if grep -qs 'YOUR_' lib/config/firebase/firebase_options.dart; then
    echo "WARN: lib/config/firebase/firebase_options.dart still has YOUR_* placeholders" >&2
  fi
fi
if [ "$DRY" = 0 ]; then
  command -v gh >/dev/null || fail "GitHub CLI (gh) not installed"
  gh auth status >/dev/null 2>&1 || fail "not logged in: run 'gh auth login'"
  [ -n "$(git branch -r --contains HEAD)" ] || fail "HEAD is not pushed; push your commit first"
  if gh release view "$TAG" >/dev/null 2>&1; then
    echo "Release $TAG exists; artifacts will be re-uploaded (--clobber)."
  fi
fi

# --- Build ------------------------------------------------------------------
run flutter pub get
run dart run build_runner build --delete-conflicting-outputs
run dart run easy_localization:generate -S assets/translations -f keys \
  -O lib/config/constants/gen -o locale_keys.g.dart

BUILD_FLAGS=(--release --obfuscate "--split-debug-info=$SYMBOLS_DIR" "--dart-define-from-file=$ENV_FILE")
run flutter build apk "${BUILD_FLAGS[@]}"
[ "$AAB" = 0 ] || run flutter build appbundle "${BUILD_FLAGS[@]}"

# --- Package artifacts ------------------------------------------------------
ASSETS=("$OUT/$BASE.apk")
run mkdir -p "$OUT"
run cp build/app/outputs/flutter-apk/app-release.apk "$OUT/$BASE.apk"
if [ "$AAB" = 1 ]; then
  run cp build/app/outputs/bundle/release/app-release.aab "$OUT/$BASE.aab"
  ASSETS+=("$OUT/$BASE.aab")
fi
# Dart symbols (needed to de-obfuscate crash stack traces) + R8 mapping if present.
run tar -czf "$OUT/$BASE-symbols.tar.gz" "$SYMBOLS_DIR" \
  $( [ -f build/app/outputs/mapping/release/mapping.txt ] && echo build/app/outputs/mapping/release/mapping.txt )
ASSETS+=("$OUT/$BASE-symbols.tar.gz")

# --- Publish ----------------------------------------------------------------
if [ "$DRY" = 0 ] && gh release view "$TAG" >/dev/null 2>&1; then
  run gh release upload "$TAG" "${ASSETS[@]}" --clobber
else
  NOTE_ARGS=(--generate-notes); [ -z "$NOTES" ] || NOTE_ARGS=(--notes "$NOTES")
  run gh release create "$TAG" "${ASSETS[@]}" --title "$TAG" \
    --target "$(git rev-parse HEAD)" "${NOTE_ARGS[@]}" ${PRERELEASE[@]+"${PRERELEASE[@]}"}
fi
echo "Done: $TAG"
