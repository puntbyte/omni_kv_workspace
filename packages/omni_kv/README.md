# OmniKV

<p align="center">
  <img src="../../logo.svg" alt="OmniKV Logo" height="400">
</p>

[![pub package](https://img.shields.io/pub/v/omni_kv.svg)](https://pub.dev/packages/omni_kv)
[![Dart Platform](https://img.shields.io/badge/Platform-Dart%20%7C%20Flutter-02569B?logo=dart)](https://dart.dev)

**OmniKV** is a strongly-typed, storage-agnostic key-value framework for Dart and Flutter.

It is designed to completely eliminate magic strings, implicit type casting, and runtime parsing
errors when dealing with app settings, feature flags, auth tokens, and local caches. By utilizing
modern Dart 3 features (dot shorthands, records, exhaustive switches), it provides the most
ergonomic and type-safe storage API available.

### Why OmniKV?

- 🛡️ **Absolute Type Safety:** Keys are bound to their Dart types (`KvKey<int>`). No more
  `prefs.getInt('magic_string') as int`.
- 🛑 **Null-Safety by Design:** Missing values are handled at compile-time. You either provide a
  `defaultValue` or mark the key `.required()` (which throws a descriptive exception if the value is
  missing).
- 🧩 **Capability-Driven:** Adapters declare what they support (`Readable`, `Writable`, `Watchable`).
  If a backend doesn't support watching, calling `.watch()` fails at *compile-time*.
- 🧹 **Safe Scoped Clearing:** Codecs own a `prefix`, and Keys own a `namespace`. Calling
  `gateway.clear()` only deletes keys that belong to your app, leaving third-party package keys
  untouched.
- 🧪 **Mock-Free Testing:** Comes with `MemoryKvAdapter` built-in. Test your business logic instantly
  without mocking platform channels.

---

## Table of Contents

1. [Installation](#1-installation)
2. [Defining Keys & Namespaces](#2-defining-keys--namespaces)
3. [Initializing the Gateway](#3-initializing-the-gateway)
4. [Operations (Read, Write, Watch, Batch)](#4-operations-read-write-watch-batch)
5. [Converters API](#5-converters-api)
6. [Capabilities Architecture (For AI & Advanced Devs)](#6-capabilities-architecture)
7. [Creating Custom Adapters](#7-creating-custom-adapters)

---

## 1. Installation

OmniKV is split into a pure-Dart core and multiple backend adapters.

### 1.1 Using the Command Line

**Add the core package (Pure Dart / Testing):**
```bash
dart pub add omni_kv
```

**Add an adapter and its required storage SDK (Flutter):**
If you want to use a specific backend, install both the OmniKV adapter *and* the official storage package.

```bash
flutter pub add omni_kv_shared_preferences shared_preferences
# OR
flutter pub add omni_kv_secure_storage flutter_secure_storage
# OR
flutter pub add omni_kv_hive_ce hive_ce
```

### 1.2 Using `pubspec.yaml`

Alternatively, manually add the dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  # Core framework (includes MemoryKvAdapter)
  omni_kv: ^0.1.0
  
  # Example: SharedPreferences Adapter
  shared_preferences: ^2.5.5
  omni_kv_shared_preferences: ^0.1.0
```

---

## 2. Defining Keys & Namespaces

The core philosophy of OmniKV is centralizing key definitions and leveraging **Dart 3.10 dot
shorthands** for maximum ergonomics.

We define a custom Key class that extends `KvKey<T>` and assigns a `namespace`. Then, we create an
`extension` on `KvGateway`. This extension acts as a gateway scope, allowing the compiler to resolve
dot shorthands contextually.

```dart
import 'package:omni_kv/omni_kv.dart';

// 1. Define your scoped Key class
final class AppKey<T> extends KvKey<T> {
  // We inject the namespace 'app' into the super constructor.
  const AppKey(super.id, {required super.defaultValue, super.converter}) 
      : super(namespace: 'app');

  const AppKey.required(super.id, {super.converter}) 
      : super.required(namespace: 'app');

  // A key with a default value
  static const launchCount = AppKey<int>('launch_count', defaultValue: 0);

  // An optional key (defaultValue is null)
  static const userName = AppKey<String?>('user_name', defaultValue: null);

  // A required key (throws MissingValueKvException if missing)
  static const token = AppKey<String>.required('token');
}

// 2. THE NAMESPACE EXTENSION
// This allows you to write: kv.app(.launchCount)
extension AppKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}
```

---

## 3. Initializing the Gateway

To interact with storage, you wrap an Adapter inside a `KvGateway`. The Gateway provides the fluent
API, while the Adapter handles the raw storage execution.

```dart
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_shared_preferences/omni_kv_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Using SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final sharedKv = KvGateway(
    SharedPreferencesKvAdapter(
      prefs,
      codec: const SharedPreferencesKvCodec(prefix: 'my_company.my_app.'),
    ),
  );

  // Using Memory (Perfect for Unit Testing!)
  final memoryKv = KvGateway(
    MemoryKvAdapter(
      codec: const MemoryKvCodec(prefix: 'test_env.'),
    ),
  );
}
```

> **Note on Prefixes vs Namespaces:**
> The `Codec(prefix: 'my_company.')` ensures your app doesn't wipe out other plugins' data on the
> device.
> The `KvKey(namespace: 'app')` organizes your logical keys internally.
> The final underlying storage key becomes: `my_company.app.launch_count`.

---

## 4. Operations (Read, Write, Watch, Batch)

Once your gateway is set up, you use the namespace extension (e.g., `.app`) alongside Dart's dot
shorthand to interact with your data.

### 4.1 Standard Operations
```dart
// Write
await kv.app(.launchCount).write(1);

// Read (returns 1)
final count = await kv.app(.launchCount).read();

// Exists
final hasToken = await kv.app(.token).exists();

// Remove
await kv.app(.token).remove();

// Clear (Safely deletes ONLY keys starting with your Codec prefix)
await kv.clear();
```

### 4.2 Reactive Watching

If your adapter supports `WatchableKvCapability` (like Memory or Hive CE), you can stream changes
natively.

```dart
final subscription = kv.app(.launchCount).watch().listen((change) {
  print('Changed from ${change.previousValue} to ${change.value}');
});
```

### 4.3 Batching

OmniKV supports asynchronous, ordered execution of multiple operations. Adapters that support
transactional batching will optimize this under the hood.

```dart
await kv.batch((tx) async {
  await tx.app(.launchCount).write(3);
  await tx.app(.userName).write('Alice');
  await tx.app(.token).remove();
});
```
---

## 5. Converters

Converters transform complex Dart types into primitive storage types supported by the underlying
database. OmniKV includes a comprehensive set of built-in converters for common use cases.

### 5.1 Built-in Converters

#### `BigIntKvConverter`

Stores `BigInt` values as strings.

- `BigIntKvConverter.toString()`
    - Encodes `BigInt` → `String`
    - Safely preserves arbitrarily large numbers

#### `CollectionKvConverter`

Converters for collection types.

- `ListKvConverter(elementConverter)`
    - Applies a converter to each list element

- `SetKvConverter(elementConverter)`
    - Encodes `Set<T>` as `List<S>`
    - Decodes stored lists back into sets

#### `DateTimeKvConverter`

Converters for `DateTime` values.

- `DateTimeKvConverter.toIsoString()`
    - Encodes `DateTime` as an ISO 8601 string
    - Recommended for string-based storage backends such as SharedPreferences and SecureStorage

- `DateTimeKvConverter.toMilliseconds()`
    - Encodes `DateTime` as milliseconds since epoch
    - Recommended for high-performance local storage such as Hive and memory caches

#### `DurationKvConverter`

Stores `Duration` values as integers.

- `DurationKvConverter.toMilliseconds()`
    - Encodes `Duration` as total milliseconds

#### `EnumKvConverter`

Converters for enum values.

- `EnumKvConverter.toName(Enum.values)`
    - Stores the enum name (for example, `'dark'`)
    - Recommended for long-term persistence because it remains stable when enum order changes

- `EnumKvConverter.toIndex(Enum.values)`
    - Stores the enum index as an integer
    - More compact, but can break if enum values are reordered

#### `JsonKvConverter`

Converters for JSON-compatible structures.

- `JsonKvConverter.toObject()`
    - Assumes `Map<String, dynamic>`

- `JsonKvConverter.toList()`
    - Assumes `List<dynamic>`

#### `ModelKvConverter`

Converters for custom model classes.

- `ModelKvConverter.toJsonString(...)`
    - Encodes models as JSON strings
    - Ideal for string-only storage backends such as SharedPreferences and SecureStorage

- `ModelKvConverter.toMap(...)`
    - Encodes models as raw maps
    - Ideal for databases with native map support, such as Hive

#### `RecordKvConverter`

Converters for Dart 3 records.

- `RecordKvConverter.toJsonString(...)`
- `RecordKvConverter.toMap(...)`

These work similarly to `ModelKvConverter`, but are designed for Dart records.

#### `UriKvConverter`

Stores `Uri` values as strings.

- `UriKvConverter.toString()`
    - Encodes `Uri` ↔ `String`

### 5.2 Inline Converter

For simple one-off conversions, use `InlineKvConverter` instead of creating a dedicated converter
class.

```dart

static const userId = AppKey<UserId>(
  'user_id',
  defaultValue: UserId(0),
  converter: InlineKvConverter<UserId, int>(
    onEncode: (id) => id.value,
    onDecode: (value) => UserId(value! as int),
  ),
);
```

### 5.3 Custom Converter

To create a reusable converter, implement `KvConverter<T, S>`:

- `T` — the Dart type used by your application
- `S` — the primitive type stored by the database

Custom converters allow OmniKV to work with any domain-specific type while maintaining type safety
throughout your application.

---

## 6. Capabilities Architecture

**For AI Code Agents and Architecture Reviewers:**

OmniKV adheres strictly to the **Interface Segregation Principle (ISP)**. The `KvGateway` itself has
no methods. Instead, it exposes extension methods conditionally based on the `KvCapability` mixins
implemented by the underlying `KvAdapter`.

This means if you attempt to call `.watch()` on the `SharedPreferencesKvAdapter` (which does not
implement `WatchableKvCapability`), the code will **fail to compile**.

Available capabilities:
*   `ReadableKvCapability`: Exposes `.read()` and `.exists()`.
*   `WritableKvCapability`: Exposes `.write()`.
*   `RemovableKvCapability`: Exposes `.remove()`.
*   `ClearableKvCapability`: Exposes `.clear()`.
*   `WatchableKvCapability`: Exposes `.watch()`.
*   `BatchableKvCapability`: Exposes `.batch()`.

---

## 7. Creating Custom Adapters

OmniKV is entirely storage-agnostic. You can easily build an adapter for `Isar`, `Sqflite`, `Drift`,
or even a remote REST API.

To create an adapter, you must implement two components:

1. **The Codec** (`KvStorageCodec`): Manages prefixing to isolate keys.
2. **The Adapter** (`KvAdapter`): The concrete class implementing the capabilities.

### 7.1. The Codec Implementation

```dart
import 'package:omni_kv/omni_kv.dart';

final class CustomKvCodec implements KvCodec {
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

### 7.2. The Adapter Implementation

```dart
final class CustomKvAdapter
    with SequentialKvBatchCapability // Mixin that provides default sequential batching
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability {

  CustomKvAdapter(this.database, {this.codec = const CustomKvCodec()});

  final MyDatabase database;

  @override
  final KvCodec codec;

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