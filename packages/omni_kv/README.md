<p align="center">
  <img src="../../logo.svg" alt="OmniKV Logo" height="400">
</p>

# OmniKV

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
- 🛑 **Null-Safety by Design:** Missing values are handled at compile-time. Provide a static `defaultValue`, a dynamic `defaultBuilder`, or mark the key `.required()`.
- 🧩 **Capability-Driven:** Adapters declare what they support (`Readable`, `Writable`, `Watchable`).
  If a backend doesn't support watching, calling `.watch()` fails at *compile-time*.
- 🧹 **Safe Scoped Clearing:** Codecs own a `prefix`, and Keys own a `namespace`. Calling
  `gateway.clear()` only deletes keys that belong to your app, leaving third-party package keys
  untouched.
- 🚀 **Enterprise Patterns Built-In:** Comes with Fast Caching, Logging Decorators, and Encryption Codecs right out of the box.

---

## Table of Contents

1. [Installation](#1-installation)
2. [Defining Keys & Namespaces](#2-defining-keys--namespaces)
3. [Initializing the Gateway](#3-initializing-the-gateway)
4. [Operations (Read, Write, Watch, Batch)](#4-operations-read-write-watch-batch)
5. [Advanced Patterns (Caching, Logging, Crypto)](#5-advanced-patterns-caching-logging-crypto)
6. [Converters API](#6-converters-api)
7. [Capabilities Architecture (For AI & Advanced Devs)](#7-capabilities-architecture)
8. [Creating Custom Adapters](#8-creating-custom-adapters)

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
  # Core framework (includes MemoryKvAdapter and advanced decorators)
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
  // Static default value
  const AppKey(super.id, {required super.defaultValue, super.converter}) 
      : super(namespace: 'app');

  // Dynamic default value (evaluated lazily on read)
  const AppKey.builder(super.id, {required super.defaultBuilder, super.converter}) 
      : super.builder(namespace: 'app');

  // Throws an exception if missing
  const AppKey.required(super.id, {super.converter}) 
      : super.required(namespace: 'app');

  // A key with a static default value
  static const launchCount = AppKey<int>('launch_count', defaultValue: 0);

  // A required key (throws MissingValueKvException if missing)
  static const token = AppKey<String>.required('token');

  // A key with a dynamic default (creates a fresh DateTime when read)
  static final sessionStartedAt = AppKey<DateTime>.builder(
    'session_started',
    defaultBuilder: () => DateTime.now(),
    converter: const DateTimeKvConverter.toIsoString(),
  );
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
> The `Codec(prefix: 'my_company.')` isolates your app so it doesn't wipe out other plugins' data on the device.
> The `KvKey(namespace: 'app')` organizes your logical keys internally.
> The final physical storage key becomes: `my_company.app.launch_count`.

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

### 4.2 Reactive Watching & Namespace Streaming

If your adapter supports `WatchableKvCapability`, you can stream individual key changes. If it supports `NamespaceWatchableKvCapability`, you can stream *everything* under a namespace!

```dart
// Watch a single key
kv.app(.launchCount).watch().listen((change) {
  print('Count changed from ${change.previousValue} to ${change.value}');
});

// Watch an entire namespace!
kv.watchNamespace('app').listen((change) {
  print('Something in the "app" namespace changed: ${change.key}');
});
```

### 4.3 Batching

OmniKV supports asynchronous, ordered execution of multiple operations.

```dart
await kv.batch((scope) async {
  await scope.app(.launchCount).write(3);
  await scope.app(.token).remove();
});
```

---

## 5. Advanced Patterns (Caching, Logging, Crypto)

OmniKV's capability-driven architecture makes it trivial to layer advanced behaviors onto any storage backend using the Decorator Pattern.

### 5.1 The "Fast Cache" Pattern (`CachedKvAdapter`)
**Problem:** `flutter_secure_storage` is extremely slow on some platforms, meaning you can't read tokens synchronously or every frame.
**Solution:** `CachedKvAdapter` wraps a slow persistent adapter with an instant memory cache. Reads return instantly. Writes update the UI immediately and sync to disk asynchronously.

```dart
final kv = KvGateway(
  CachedKvAdapter(
    primary: MemoryKvAdapter(),
    persistent: SecureStorageKvAdapter(storage),
  ),
);
```

### 5.2 The Logging Decorator (`LoggingKvAdapter`)
Wrap any adapter to automatically log every read, write, and stream to the console. Invaluable for debugging disk I/O.

```dart
final kv = KvGateway(
  LoggingKvAdapter(
    SharedPreferencesKvAdapter(prefs),
    logger: (msg) => print('[MY_APP] $msg'),
  ),
);
```

### 5.3 Encryption at Rest (`EncryptedKvCodec`)
Apply fast software encryption (like AES256) to data *before* it hits the persistent adapter.

```dart
final kv = KvGateway(
  HiveCeKvAdapter(
    box,
    codec: EncryptedKvCodec(
      delegate: const HiveCeKvCodec(prefix: 'app.'),
      onEncrypt: (payload) => MyCryptoService.encrypt(payload),
      onDecrypt: (payload) => MyCryptoService.decrypt(payload),
    ),
  ),
);
```

---

## 6. Converters API

Converters transform complex Dart types into primitive storage types supported by the underlying
database.

### 6.1 Built-in Converters

#### `BigIntKvConverter`
- `BigIntKvConverter.toString()`: Encodes arbitrarily large numbers as strings.

#### `CollectionKvConverter`
- `ListKvConverter(elementConverter)`: Applies a converter to each list element.
- `SetKvConverter(elementConverter)`: Encodes `Set<T>` as `List<S>` for storage.

#### `DateTimeKvConverter`
- `DateTimeKvConverter.toIsoString()`: Recommended for string-based backends (SharedPreferences, SecureStorage).
- `DateTimeKvConverter.toMilliseconds()`: Recommended for high-performance caches (Hive, Memory).

#### `DurationKvConverter`
- `DurationKvConverter.toMilliseconds()`: Stores durations as integers.

#### `EnumKvConverter`
- `EnumKvConverter.toName(Enum.values)`: Stores the enum name. Stable when enum order changes.
- `EnumKvConverter.toIndex(Enum.values)`: Stores the index. Compact, but risky if reordered.

#### `JsonKvConverter`
- `JsonKvConverter.toObject()`: Assumes `Map<String, dynamic>`.
- `JsonKvConverter.toList()`: Assumes `List<dynamic>`.

#### `ModelKvConverter` / `RecordKvConverter`
- `ModelKvConverter.toJsonString(...)`: Encodes custom classes/records to JSON strings.
- `ModelKvConverter.toMap(...)`: Encodes custom classes/records to raw maps natively.

#### `UriKvConverter`
- `UriKvConverter.toString()`: Encodes Uris as strings.

### 6.2 Inline & Custom Converters

For simple one-off conversions, use `InlineKvConverter`:

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

To create a reusable converter, simply implement the `KvConverter<T, S>` interface.

---

## 7. Capabilities Architecture

**For AI Code Agents and Architecture Reviewers:**

OmniKV adheres strictly to the **Interface Segregation Principle (ISP)**. The `KvGateway` itself has
no methods. Instead, it exposes extension methods conditionally based on the `KvCapability` mixins
implemented by the underlying `KvAdapter`.

This means if you attempt to call `.watch()` on the `SharedPreferencesKvAdapter` (which does not natively
implement `WatchableKvCapability`), the code will **fail to compile**.

Available capabilities:
*   `ReadableKvCapability`: Exposes `.read()` and `.exists()`.
*   `WritableKvCapability`: Exposes `.write()`.
*   `RemovableKvCapability`: Exposes `.remove()`.
*   `ClearableKvCapability`: Exposes `.clear()`.
*   `WatchableKvCapability`: Exposes `.watch(key)`.
*   `NamespaceWatchableKvCapability`: Exposes `.watchNamespace(prefix)`.
*   `BatchableKvCapability`: Exposes `.batch()`.

---

## 8. Creating Custom Adapters

OmniKV is entirely storage-agnostic. You can easily build an adapter for `Isar`, `Sqflite`, `Drift`,
or a remote REST API. To create an adapter, implement two components:

### 8.1. The Codec Implementation
Manages prefixing to isolate keys globally on the device.

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

### 8.2. The Adapter Implementation
Implements the interfaces declaring exactly what this storage engine can do.

```dart
final class CustomKvAdapter
    with SequentialKvBatchCapability // Mixin providing default sequential batching
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