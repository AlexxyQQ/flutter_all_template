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

### 3. Releasing

Android is signed and built **on your machine**, never in GitHub Actions, so the keystore
never leaves it and no secrets need to be stored in GitHub. `scripts/release.sh` refuses
to run (outside `--dry-run`) when `android/key.properties` is missing, so you cannot
upload a debug-signed build by accident. See `docs/CI_CD.md`.

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
4. Build the IPA on a Mac (`flutter build ipa --release --dart-define-from-file=env/prod.json`)
   and upload `build/ios/ipa/*.ipa` with Transporter or `xcrun altool`.

### Codemagic (no Mac needed)

`codemagic.yaml` signs iOS builds automatically with an **App Store Connect API key**;
you never handle certificates or profiles yourself.

1. App Store Connect > Users and Access > Integrations > App Store Connect API: create a
   key with the **App Manager** role. Download the `.p8` once.
2. Codemagic > Teams > Integrations > App Store Connect: add the key (Issuer ID, Key ID,
   `.p8`) and name the integration `codemagic` (the name used in `codemagic.yaml`).
3. Make sure the App ID (bundle id, same as `PRODUCT_BUNDLE_IDENTIFIER` and the
   `bundle_id` anchor in `codemagic.yaml`) exists and the app record is created in
   App Store Connect.
4. On each build Codemagic fetches or creates the **Apple Distribution** certificate and
   an App Store profile (`ios_signing` + `fetch-signing-files --create`).

Apple allows a limited number of distribution certificates per account; if creation
fails, either delete an unused one in Apple Developer or add your own certificate private
key in Codemagic (`CERTIFICATE_PRIVATE_KEY`, see the Codemagic docs).

## Rotating or revoking

- Android upload key compromised → request an upload key reset in Play Console; with
  Play App Signing the app signing key is unaffected.
- iOS certificate compromised → revoke it in Apple Developer, regenerate with `match nuke`
  + `match` (or manually), update the Codemagic integration.
- Always rotate the Codemagic secrets afterwards and audit recent builds.
