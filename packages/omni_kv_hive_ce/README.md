# OmniKV: Hive CE

[![pub package](https://img.shields.io/pub/v/omni_kv_hive_ce.svg)](https://pub.dev/packages/omni_kv_hive_ce)

The official `hive_ce` adapter for [OmniKV](https://pub.dev/packages/omni_kv).

## Installation

You must install both the adapter and the underlying storage package:

```bash
flutter pub add omni_kv omni_kv_hive_ce hive_ce
```

## Quick Start

Initialize your `KvGateway` with the `HiveCeKvAdapter`:

```dart
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_hive_ce/omni_kv_hive_ce.dart';
import 'package:hive_ce/hive.dart';

Future<void> main() async {
  // Ensure Hive is initialized for your platform first!
  // await Hive.initFlutter();
  
  final box = await Hive.openBox<Object?>('settings');
  
  final kv = KvGateway(
    HiveCeKvAdapter(
      box,
      codec: const HiveCeKvCodec(prefix: 'my_app.'),
    ),
  );

  // Ready to use!
}
```

## Features

- **Watchable Streams:** Because Hive CE natively supports watching boxes, this adapter implements
  `WatchableKvCapability`. You can call `.watch()` on any key to get a continuous stream of changes.
- **Encryption at Rest:** You can easily wrap `HiveCeKvCodec` in OmniKV's built-in
  `EncryptedKvCodec` to apply AES encryption to your data before it hits the disk.
- **Native Maps:** Hive natively supports raw Maps and Lists. If you use `ModelKvConverter.toMap()`
  or `RecordKvConverter.toMap()` on your keys, data will be stored natively instead of being
  stringified to JSON.
- **Scoped Clearing:** By providing a `prefix` to the codec, calling `kv.clear()` will **only**
  delete keys that start with that prefix from the Hive box.

For full documentation on how to define keys and use the fluent API, see
the [core OmniKV package](https://pub.dev/packages/omni_kv).
