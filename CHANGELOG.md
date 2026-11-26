# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [3.0.0]

### Changed

- `flutter_feature` brick now generates the route, wrapper, list screen, widgets and a widget test, registers the route in `AppRouter` and adds the translation keys to `en-GB.json` / `ne-NP.json`.
- Consolidate the todo repository's fetch-and-cache logic and improve AutoRoute navigation across nested stacks.
- Require one class per Dart file, with instance or class members in place of top-level state and helpers.

### Added

- Reusable popup dialogs and bottom sheets with typed results.
- Per-user analytics with an encrypted local store and optional Firebase and custom API destinations.
- Hive CE storage with authenticated encryption and keys held in platform secure storage.

## [0.0.1] — 2026--11-26

### Added

- Initial repository created
