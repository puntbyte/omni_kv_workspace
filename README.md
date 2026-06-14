<p align="center">
  <img src="logo.svg" alt="OmniKV Logo" height="400">
</p>

# OmniKV Workspace

[![Dart Platform](https://img.shields.io/badge/Platform-Dart%20%7C%20Flutter-02569B?logo=dart)](https://dart.dev)
[![Melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

Welcome to the **OmniKV** monorepo!

**OmniKV** is a strongly-typed, storage-agnostic key-value framework for Dart and Flutter. It
completely eliminates magic strings, implicit type casting, and runtime parsing errors when dealing
with app settings, feature flags, auth tokens, and local caches.

> **Note:** If you are looking for documentation on how to use OmniKV in your app, please see
> the [core package documentation](packages/omni_kv/README.md).

---

## 📦 Packages

This repository is managed as a workspace using [Melos](https://melos.invertase.dev/). It contains
the pure-Dart core package alongside several officially supported storage adapters.

| Package                                                             | Version                                                                                                                    | Description                                                                           |
|---------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| [`omni_kv`](packages/omni_kv)                                       | [![pub](https://img.shields.io/pub/v/omni_kv.svg)](https://pub.dev/packages/omni_kv)                                       | Pure Dart core APIs, typed keys, converters, capabilities, and the `MemoryKvAdapter`. |
| [`omni_kv_shared_preferences`](packages/omni_kv_shared_preferences) | [![pub](https://img.shields.io/pub/v/omni_kv_shared_preferences.svg)](https://pub.dev/packages/omni_kv_shared_preferences) | Flutter adapter backed by `shared_preferences`.                                       |
| [`omni_kv_secure_storage`](packages/omni_kv_secure_storage)         | [![pub](https://img.shields.io/pub/v/omni_kv_secure_storage.svg)](https://pub.dev/packages/omni_kv_secure_storage)         | Flutter adapter backed by `flutter_secure_storage`.                                   |
| [`omni_kv_hive_ce`](packages/omni_kv_hive_ce)                       | [![pub](https://img.shields.io/pub/v/omni_kv_hive_ce.svg)](https://pub.dev/packages/omni_kv_hive_ce)                       | Dart/Flutter adapter backed by `hive_ce`.                                             |

---

## 🏗️ Workspace Structure

```text
omni_kv_workspace/
├── pubspec.yaml              # Workspace root configuration
├── melos.yaml                # Melos configuration and scripts
├── analysis_options.yaml     # Shared strict linting rules
│
├── packages/                 # Core framework and adapters
│   ├── omni_kv/
│   ├── omni_kv_hive_ce/
│   ├── omni_kv_secure_storage/
│   └── omni_kv_shared_preferences/
│
└── example/                  # Comprehensive example app
    ├── bin/                  # Pure Dart CLI demos
    └── lib/                  # Flutter visual demo
```

---

## 🚀 Running the Examples

The `example` directory contains both pure Dart CLI applications and a fully functional Flutter
application demonstrating all the adapters.

**Run the pure Dart Memory & Hive examples:**
```bash
cd example
dart run bin/main.memory.dart
dart run bin/main.hive_ce.dart
```

**Run the Flutter example (SharedPreferences & Secure Storage):**
```bash
cd example
flutter run -t lib/main.dart
```

---

## 🛠️ Contributing & Development

This repository relies on [Melos](https://melos.invertase.dev/) to manage the multi-package setup.

### 1. Initial Setup

First, activate Melos globally and bootstrap the workspace to link all local dependencies together.
```bash
dart pub global activate melos
melos bootstrap
```

### 2. Useful Commands

We have configured several Melos scripts to ensure code quality across the entire workspace.

**Format all code:**
```bash
melos run format:apply
```

**Run static analysis (linting):**
```bash
melos run analyze
```

**Run all tests (Dart & Flutter):**
```bash
melos run test
```

*(This automatically runs `dart test` for pure Dart packages and `flutter test` for
Flutter-dependent packages).*

---

## 📜 License

This workspace is licensed under the MIT License.
