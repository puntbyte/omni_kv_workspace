# PolyKV

[![pub package](https://img.shields.io/pub/v/poly_kv.svg)](https://pub.dev/packages/poly_kv)
[![Dart Platform](https://img.shields.io/badge/Platform-Dart%20%7C%20Flutter-02569B?logo=dart)](https://dart.dev)

**PolyKV** is a strongly-typed, storage-agnostic key-value framework for Dart and Flutter.

It is designed to completely eliminate magic strings, implicit type casting, and runtime parsing
errors when dealing with app settings, feature flags, auth tokens, and local caches.

## Why PolyKV?

- 🛡️ **Absolute Type Safety:** Keys are bound to their Dart types (`KvKey<int>`). No more
  `prefs.getInt('magic_string') as int`.
- 🛑 **Null-Safety by Design:** Missing values are handled at compile-time. You either provide a
  `defaultValue`, make the type nullable, or mark it `.required()` (which throws a descriptive
  exception if missing).
- 🧩 **Capability-Driven:** Adapters declare what they support (`Readable`, `Writable`, `Watchable`).
  If a backend doesn't support watching, calling `.watch()` fails at *compile-time*.
- 🧹 **Safe Scoped Clearing:** Codecs own a `prefix`. Calling `gateway.clear()` only deletes keys
  that belong to your app, leaving third-party package keys untouched.
- 🧪 **Mock-Free Testing:** Comes with `MemoryKvAdapter` built-in. Test your business logic instantly
  without mocking platform channels.

## Ecosystem & Installation

PolyKV is split into a pure-Dart core and multiple backend adapters.

**1. Add the core package:**

```bash
dart pub add poly_kv
```

**2. Add an adapter and its required storage SDK (Optional):**
If you want to use a specific backend (like SharedPreferences), you must install both the PolyKV
adapter *and* the official storage package.

```bash
flutter pub add poly_kv_shared_preferences shared_preferences
# OR
flutter pub add poly_kv_secure_storage flutter_secure_storage
# OR
flutter pub add poly_kv_hive_ce hive_ce
```

---

## Quick Start

### 1. Define your Keys (The Recommended Way)

Centralize your keys in one file. PolyKV uses a 2-constructor design to optimize for the most common
use-cases while strictly enforcing null-safety:

* **The Unnamed Constructor:** Used for 90% of keys. It enforces a `defaultValue` (which can be
  `null` if the type is nullable).
* **The `.required()` Constructor:** Used for edge cases where missing data is a critical error. It
  throws a `KvMissingValueException` if the value is absent.

We highly recommend adding a **Namespace Extension** to your `KvGateway`. This eliminates
boilerplate and allows for beautiful, autocomplete-friendly syntax like `gateway.app(.theme)`.

```dart
import 'package:omni_kv/omni_kv.dart';

final class AppKey<T> extends KvKey<T> {
  const AppKey(super.name, {required super.defaultValue, super.converter});

  const AppKey.required(super.name, {super.converter}) : super.required();

  // A key with a default value
  static const launchCount = AppKey<int>('app.launch_count', defaultValue: 0);

  // An optional key (defaultValue is null)
  static const userName = AppKey<String?>('app.user_name', defaultValue: null);

  // A required key (throws if missing)
  static const token = AppKey<String>.required('app.token');
}

// THE NAMESPACE EXTENSION
// This allows you to write: kv.app(.launchCount)
extension AppKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}
```

### 2. Initialize the Gateway

Wrap your chosen adapter in a `KvGateway`.

```dart
// Using the built-in Memory adapter for pure Dart / Testing
final kv = KvGateway(
  MemoryKvAdapter(
    codec: const MemoryKvCodec(prefix: 'my_app.'),
  ),
);
```

### 3. Read, Write, and Remove

Use the fluent namespace API to interact with your keys.

```dart
// Write
await
kv.app
(.launchCount).write(1);

// Read (returns 1)
final count = await kv.app(.launchCount).read();

// Exists
final hasToken = await kv.app(.token).exists();

// Remove
await kv.app(.token).remove();
```

### 4. Batch Operations

PolyKV supports asynchronous, ordered execution of multiple operations.

```dart
await
kv.batch
(
(tx) async {
await tx.app(.launchCount).write(3);
await tx.app(.userName).write('Alice');
await tx.app(.token).remove();
});
```

---

## Advanced Usage

### Capabilities

PolyKV's API is fully modular. The methods available on `KvGateway` depend entirely on what
interfaces the underlying adapter implements. This ensures you never attempt an unsupported
operation at runtime.

Available capabilities include:

- `ReadableKvCapability`: Enables `.read()` and `.exists()`.
- `WritableKvCapability`: Enables `.write()`.
- `RemovableKvCapability`: Enables `.remove()`.
- `ClearableKvCapability`: Enables `.clear()`.
- `WatchableKvCapability`: Enables `.watch()` (Streams value changes).
- `BatchableKvCapability`: Enables `.batch()`.

### Converters

Converters translate complex Dart types into primitive types safe for databases.

#### Supported Built-in Converters:

- `BigIntConverter`: `.toString()`
- `CollectionConverter`: `ListConverter`, `SetConverter`
- `DateTimeConverter`: `.toIsoString()`, `.toMilliseconds()`
- `DurationConverter`: `.toMilliseconds()`
- `EnumConverter`: `.toName()`, `.toIndex()`
- `JsonConverter`: `.toObject()`, `.toList()`
- `ModelConverter`: `.toMap()`, `.toJsonString()`
- `RecordConverter`: `.toMap()`, `.toJsonString()`
- `UriConverter`: `.toString()`
- `InlineConverter`: (Takes quick `onEncode` and `onDecode` callbacks)

#### Custom Converters

If the built-in converters don't fit your needs, you can create a custom converter by implementing
`KvConverter<T, S>` (where `T` is your Dart type, and `S` is the storage type).

```dart
import 'package:omni_kv/omni_kv.dart';

final class ColorHexConverter implements KvConverter<Color?, int?> {
  const ColorHexConverter();

  @override
  int? encode(Color? value) => value?.value;

  @override
  Color? decode(Object? value) {
    if (value == null) return null;
    return Color(value as int);
  }
}

// Usage:
static const themeColor = AppKey<Color>(
  'app.color',
  defaultValue: Color(0xFF000000),
  converter: ColorHexConverter(),
);
```

---

## Creating a Custom Adapter

PolyKV is storage-agnostic. You can easily build your own adapter for `Isar`, `Sqflite`, `Drift`, or
a custom remote API.

To create an adapter, you need two things:

1. A **Codec** (`KvStorageCodec`) to handle key-prefixing and raw type validation.
2. The **Adapter** (`KvAdapter`) that talks to your database.

### 1. The Codec

```dart
import 'package:omni_kv/omni_kv.dart';

final class CustomKvCodec implements KvStorageCodec {
  const CustomKvCodec({this.prefix});

  final String? prefix;

  @override
  String storageKey(String logicalKey) =>
      prefix == null ? logicalKey : '$prefix$logicalKey';

  @override
  String logicalKey(Object? storageKey) {
    final key = storageKey as String;
    return prefix != null && key.startsWith(prefix!)
        ? key.substring(prefix!.length)
        : key;
  }

  @override
  bool ownsKey(Object? storageKey) =>
      prefix == null || (storageKey is String && storageKey.startsWith(prefix!));

  @override
  Object? encode(Object? value) => value;

  @override
  Object? decode(Object? value) => value;
}
```

### 2. The Adapter

```dart
final class CustomKvAdapter
    with SequentialKvBatchCapability // Provides basic batching automatically
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability {

  CustomKvAdapter(this.database, {this.codec = const CustomKvCodec()});

  final MyDatabase database;

  @override
  final KvStorageCodec codec;

  @override
  Future<Object?> read(String key) async {
    final rawValue = await database.get(codec.storageKey(key));
    return codec.decode(rawValue);
  }

  @override
  Future<bool> contains(String key) async {
    return database.has(codec.storageKey(key));
  }

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }
    await database.put(codec.storageKey(key), codec.encode(value));
  }

  @override
  Future<void> remove(String key) async {
    await database.delete(codec.storageKey(key));
  }
}
```