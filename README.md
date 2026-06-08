# PolyKV Workspace

`poly_kv` is a typed, storage-agnostic key-value gateway for Dart and Flutter.

It is designed for app settings, feature flags, auth/session tokens, small typed caches, CLI/server configuration, and testable key-value repositories.

## Packages

| Package | Purpose |
|---|---|
| `poly_kv` | Pure Dart core APIs, typed keys, converters, gateway, capabilities, and `MemoryKvAdapter`. |
| `poly_kv_shared_preferences` | Flutter adapter backed by `shared_preferences`. |
| `poly_kv_hive_ce` | Dart/Flutter adapter backed by Hive CE. |
| `poly_kv_secure_storage` | Flutter adapter backed by `flutter_secure_storage`. |

## Workspace structure

```text
poly_kv_workspace/
├── pubspec.yaml
├── README.md
├── analysis_options.yaml
│
├── packages/
│   ├── poly_kv/
│   │   └── lib/src/core/
│   │       └── kv_storage_codec.dart
│   ├── poly_kv_hive_ce/
│   │   └── lib/src/
│   │       ├── hive_ce_kv_adapter.dart
│   │       └── hive_ce_kv_codec.dart
│   ├── poly_kv_secure_storage/
│   │   └── lib/src/
│   │       ├── secure_storage_kv_adapter.dart
│   │       └── secure_storage_kv_codec.dart
│   └── poly_kv_shared_preferences/
│       └── lib/src/
│           ├── shared_preferences_kv_adapter.dart
│           └── shared_preferences_kv_codec.dart
│
└── example/
    ├── bin/
    │   ├── console_output.dart
    │   ├── main.hive_ce.dart
    │   └── main.memory.dart
    └── lib/
        ├── app_keys.dart
        └── main.dart
```

## Core idea

Define keys once with their value type and missing-value behavior:

```dart
import 'package:omni_kv/poly_kv.dart';

enum AppTheme { system, light, dark }

final class AppKey<T> extends KvKey<T> {
  const AppKey.required(String name, {KvConverter<T?, Object?>? converter})
    : super.required(name, converter: converter);

  const AppKey.optional(String name, {KvConverter<T?, Object?>? converter})
    : super.optional(name, converter: converter);

  const AppKey.withDefault(
    String name,
    T defaultValue, {
    KvConverter<T?, Object?>? converter,
  }) : super.withDefault(name, defaultValue, converter: converter);

  static const theme = AppKey<AppTheme>.withDefault(
    'app.theme',
    AppTheme.system,
    converter: EnumConverter.toName(AppTheme.values),
  );

  static const launchCount = AppKey<int>.withDefault('app.launch_count', 0);
  static const userName = AppKey<String?>.optional('app.user_name');
}
```

Use keys through a gateway:

```dart
final kv = KvGateway(
  MemoryKvAdapter(
    codec: const MemoryKvCodec(prefix: 'example.'),
  ),
);

await kv.write(AppKey.theme, AppTheme.dark);
await kv.write(AppKey.launchCount, 1);

final theme = await kv.read(AppKey.theme);
final count = await kv.read(AppKey.launchCount);
```

Grouped writes/removes use the same fluent entry style:

```dart
await kv.batch((entry) {
  entry.app(.theme).write(AppTheme.light);
  entry.app(.launchCount).write(2);
  entry.auth(.token).write('memory-token');
  entry.auth(.token).remove();
});

await kv.app.batch((entry) {
  entry(.theme).write(AppTheme.dark);
  entry(.launchCount).write(3);
});
```

## Capability-based API

Adapter interfaces control which APIs autocomplete:

- `ReadableKvCapability` enables `read`, `contains`, and `entry(...).read()`.
- `WritableKvCapability` enables `write` and `entry(...).write(...)`.
- `RemovableKvCapability` enables `remove`.
- `ClearableKvCapability` enables `clear`.
- `BatchableKvCapability` enables `batch`.
- `WatchableKvCapability` enables `watch`.

## Scoped clearing

Adapter packages expose backend-specific codecs that implement `KvStorageCodec`. When a codec has a prefix, `clear()` only removes keys owned by that codec scope.

```dart
final kv = KvGateway(
  SharedPreferencesKvAdapter(
    prefs,
    codec: const SharedPreferencesKvCodec(prefix: 'my_app.'),
  ),
);

await kv.clear(); // Clears only keys owned by the codec scope.
```

## Examples

```bash
cd example
dart run bin/main.memory.dart
dart run bin/main.hive_ce.dart
flutter run -t lib/main.dart
```

## Melos 7 workspace config

The root `pubspec.yaml` defines both the Dart workspace entries and the `melos:` section.

```bash
dart pub get
melos bootstrap
melos run format:check
melos run analyze
melos run test
```
