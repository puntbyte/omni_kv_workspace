# PolyKV Example

This package demonstrates both supported example styles:

```text
example/
├── bin/
│   ├── console_output.dart
│   ├── main.hive_ce.dart      # Dart console demo using Hive CE
│   └── main.memory.dart       # Dart console demo using MemoryKvAdapter
└── lib/
    ├── app_keys.dart
    └── main.dart              # Flutter demo using memory, SharedPreferences, and secure storage
```

Run the Dart demos:

```bash
cd example
dart run bin/main.memory.dart
dart run bin/main.hive_ce.dart
```

Run the Flutter demo:

```bash
cd example
flutter run -t lib/main.dart
```
