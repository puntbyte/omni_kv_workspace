# OmniKV: SharedPreferences

[![pub package](https://img.shields.io/pub/v/omni_kv_shared_preferences.svg)](https://pub.dev/packages/omni_kv_shared_preferences)

The official `shared_preferences` adapter for [OmniKV](https://pub.dev/packages/omni_kv).

## Installation

You must install both the adapter and the underlying storage package:

```bash
flutter pub add omni_kv omni_kv_shared_preferences shared_preferences
```

## Quick Start

Initialize your `KvGateway` with the `SharedPreferencesKvAdapter`.

*Pro Tip: SharedPreferences doesn't natively support streams. If you wrap it in
OmniKV's `CachedKvAdapter`, you gain the ability to `.watch()` your SharedPreferences keys!*

```dart
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_shared_preferences/omni_kv_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Wrapped in CachedKvAdapter to instantly add Stream support to SharedPreferences!
  final kv = KvGateway(
    CachedKvAdapter(
      primary: MemoryKvAdapter(),
      persistent: SharedPreferencesKvAdapter(
        prefs,
        codec: const SharedPreferencesKvCodec(prefix: 'my_app.'),
      ),
    ),
  );

  // Ready to use!
}
```

## Features & Limitations

- **Native Types:** This adapter natively supports `String`, `int`, `double`, `bool`, and
  `List<String>`.
- **Complex Types:** To store custom objects, records, or maps, you must attach a `JsonKvConverter`,
  `ModelKvConverter`, or `RecordKvConverter` to your `KvKey`.
- **Scoped Clearing:** By providing a `prefix` to the codec (e.g., `'my_app.'`), calling
  `kv.clear()` will **only** delete keys that start with that prefix. Keys created by other packages
  will remain completely safe.

For full documentation on how to define keys and use the fluent API, see
the [core OmniKV package](https://pub.dev/packages/omni_kv).
