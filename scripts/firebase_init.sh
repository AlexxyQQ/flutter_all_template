#!/usr/bin/env bash
# Create the git-ignored Firebase client config from the tracked *.example
# placeholders. Never overwrites an existing file. Safe to run repeatedly.
set -eu
cd "$(dirname "$0")/.."
for ex in \
  android/app/google-services.json.example \
  ios/Runner/GoogleService-Info.plist.example \
  firebase.json.example \
  lib/config/firebase/firebase_options.dart.example; do
  [ -f "$ex" ] || continue
  real="${ex%.example}"
  if [ -f "$real" ]; then echo "keep   $real"; else cp "$ex" "$real"; echo "create $real (placeholder)"; fi
done
echo "Next: run 'flutterfire configure' to replace the YOUR_* placeholders with your real"
echo "project config. These files are git-ignored; never commit them."
