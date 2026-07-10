# OmniKV Example

The example package demonstrates all current OmniKV features using the existing entry points:

- `bin/main.memory.dart` — typed keys, defaults, converters, batch, namespace watch, clear, close.
- `bin/main.hive_ce.dart` — Hive CE, encrypted codec, physical keys, streaming.
- `bin/main.shared.dart` — SharedPreferences with `CachedKvAdapter`, write-behind, flush.
- `bin/main.secured.dart` — Flutter Secure Storage with cached write-through access.
- `lib/main.dart` — Flutter UI that watches a typed theme key.

Run the pure Dart examples with:

```bash
dart --directory example run bin/main.memory.dart
dart --directory example run bin/main.hive_ce.dart
```

Run Flutter-backed examples with:

```bash
flutter --directory example run -d windows bin/main.shared.dart
flutter --directory example run -d windows bin/main.secured.dart
```
