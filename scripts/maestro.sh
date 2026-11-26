#!/usr/bin/env bash
# Build the dev debug APK, install it, start the stub API and run Maestro.
#   bash scripts/maestro.sh [--no-build] [maestro test args/flows...]
# Android only (iOS: see docs/MAESTRO.md). Needs: flutter, adb, maestro, node.
set -euo pipefail
cd "$(dirname "$0")/.."

BUILD=1
[ "${1:-}" = "--no-build" ] && { BUILD=0; shift; }
PORT=8080
APK=build/app/outputs/flutter-apk/app-debug.apk

for bin in maestro adb node; do
  command -v "$bin" >/dev/null || { echo "error: '$bin' not found on PATH (see docs/MAESTRO.md)" >&2; exit 1; }
done
adb get-state >/dev/null 2>&1 || { echo "error: no Android emulator/device (run 'adb devices')" >&2; exit 1; }

[ ! -f scripts/firebase_init.sh ] || bash scripts/firebase_init.sh >/dev/null  # placeholder Firebase config if absent
if [ "$BUILD" = 1 ]; then
  command -v flutter >/dev/null || { echo "error: 'flutter' not found" >&2; exit 1; }
  # localhost is reverse-forwarded to this machine (works on emulators and
  # USB devices); debug builds allow cleartext HTTP to it.
  flutter build apk --debug --dart-define-from-file=env/dev.json \
    --dart-define=BASE_URL="http://localhost:$PORT/api/v1/"
fi
[ -f "$APK" ] || { echo "error: $APK missing; run without --no-build" >&2; exit 1; }
adb install -r "$APK"

adb reverse "tcp:$PORT" "tcp:$PORT" >/dev/null
node .maestro/stub_server.mjs "$PORT" &
STUB=$!
trap 'kill $STUB 2>/dev/null || true' EXIT

maestro test "${@:-.maestro/flows}"
