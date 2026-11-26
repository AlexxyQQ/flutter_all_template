{{=<% %>=}}
# Code signing

Never commit keystores, `key.properties`, certificates, provisioning profiles or their
passwords. `.gitignore` already excludes `android/key.properties`, `*.jks` and `*.keystore`.

---

## Android

### 1. Create an upload keystore (once per app)

```bash
keytool -genkey -v -keystore ~/keys/my_app-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Store the `.jks` file and both passwords in your team password manager. If you use
**Play App Signing** (recommended), this is only the *upload* key; Google holds the app
signing key, and a lost upload key can be reset through Play Console support.

### 2. Point Gradle at it

```bash
cp android/key.properties.example android/key.properties
```

```properties
storePassword=…
keyPassword=…
keyAlias=upload
storeFile=/absolute/path/to/my_app-upload.jks   # or a path relative to android/app/
```

`android/app/build.gradle.kts` loads this file:

- **present** → the `release` build type is signed with your key;
- **missing** → release builds fall back to the **debug** key so `flutter run --release`
  works locally, and Gradle prints
  `WARNING: android/key.properties not found — the release build is signed with the DEBUG key…`.
  Such builds are rejected by Google Play. Treat that warning as an error in CI.

Release builds also enable R8 (`isMinifyEnabled = true`, `isShrinkResources = true`)
with `android/app/proguard-rules.pro`. If a plugin breaks only in release, add a `-keep`
rule there. Upload `build/app/outputs/mapping/release/mapping.txt` and the Dart
symbols in `build/symbols/<flavor>/` to your crash reporter for every release.

### 3. CI (GitHub Actions)

Store these repository **secrets**: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
`ANDROID_KEY_PASSWORD`, `ANDROID_KEY_ALIAS`.

```bash
base64 -w0 my_app-upload.jks   # macOS: base64 -i my_app-upload.jks
```

```yaml
- name: Configure Android signing
  env:
    KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
    STORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
    KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
    KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
  run: |
    echo "$KEYSTORE_BASE64" | base64 --decode > "$RUNNER_TEMP/upload.jks"
    {
      echo "storePassword=$STORE_PASSWORD"
      echo "keyPassword=$KEY_PASSWORD"
      echo "keyAlias=$KEY_ALIAS"
      echo "storeFile=$RUNNER_TEMP/upload.jks"
    } > android/key.properties

- name: Build app bundle
  run: flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/prod --dart-define-from-file=env/prod.json
```

Run release jobs only on protected branches/tags and in a GitHub **environment** with
required reviewers so that pull requests from forks never see the secrets.

### Changing the application ID

`namespace` and `applicationId` in `android/app/build.gradle.kts` are still
`com.alexxy.flutter_all_template`. Before the first Play upload (the ID can never change
afterwards):

1. Change both values.
2. Move `android/app/src/main/kotlin/com/alexxy/flutter_all_template/MainActivity.kt` to the
   new package path and update its `package` line.
3. Update `PRODUCT_BUNDLE_IDENTIFIER` for iOS (below) and re-run `flutterfire configure`.

---

## iOS

### Manual (small teams)

1. In Apple Developer, create an App ID matching `PRODUCT_BUNDLE_IDENTIFIER`
   (Xcode → Runner target → Signing & Capabilities).
2. Enable the **Push Notifications** capability if you use FCM, and upload an APNs key
   (`.p8`) to Firebase → Project settings → Cloud Messaging.
3. Let Xcode manage signing for development; for distribution export an
   **Apple Distribution** certificate (`.p12`) and an App Store provisioning profile.
4. `rps build ipa prod` → upload `build/ios/ipa/*.ipa` with Transporter or
   `xcrun altool`/`notarytool`.

### CI

Prefer [fastlane match](https://docs.fastlane.tools/actions/match/) (certificates and
profiles encrypted in a private repo/bucket) or an App Store Connect API key with
automatic signing. Required secrets typically are: `MATCH_PASSWORD`, `MATCH_GIT_URL`
(or storage credentials), and `APP_STORE_CONNECT_API_KEY_*`. Build on `macos-latest`
and keep the same rule as Android: release jobs run only on protected refs.

---

## Rotating or revoking

- Android upload key compromised → request an upload key reset in Play Console; with
  Play App Signing the app signing key is unaffected.
- iOS certificate compromised → revoke it in Apple Developer, regenerate with `match nuke`
  + `match` (or manually), update CI secrets.
- Always rotate the CI secrets afterwards and audit recent workflow runs.
