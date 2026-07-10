# OmniKV Workspace

OmniKV is a strongly typed, storage-agnostic key-value framework for Dart and Flutter.

The workspace contains:

- `omni_kv` — core typed keys, converters, capability-gated gateway API, memory adapter, decorators.
- `omni_kv_hive_ce` — Hive CE adapter.
- `omni_kv_shared_preferences` — SharedPreferences adapter.
- `omni_kv_secure_storage` — Flutter Secure Storage adapter.
- `omni_kv_testing` — reusable adapter conformance tests and fixtures.
- `example` — console and Flutter examples.

## Version

All publishable packages are aligned at `0.2.0`.

## Key ideas

OmniKV separates capability markers from adapter behavior:

```dart
abstract interface class ReadKvCapability implements KvCapability {}

abstract interface class ReadKvAdapter<TCapability extends ReadKvCapability>
    implements KvAdapter<TCapability> {
  Future<Object?> read(String key);
  Future<bool> contains(String key);
}
```

The public gateway remains ergonomic:

```dart
final kv = KvGateway(MemoryKvAdapter());
```

Operations are available only when the adapter supports the required contract. For example, `.watch()` only exists for `WatchKvAdapter` implementations.

## Run examples

```bash
dart --directory example run bin/main.memory.dart
dart --directory example run bin/main.hive_ce.dart
flutter --directory example run -d windows lib/main.dart
```

Flutter-backed console examples:

```bash
flutter --directory example pub get
flutter --directory example run -d windows bin/main.shared.dart
flutter --directory example run -d windows bin/main.secured.dart
```

## Workspace commands

```bash
dart pub get
melos run format:apply
melos run analyze
melos run test
melos run publish:dry-run
```

## Documentation

See `docs/` for the release checklist, capability guide, adapter guide, examples, and troubleshooting notes.
