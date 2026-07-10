# omni_kv_hive_ce

Hive CE adapter for OmniKV.

## Usage

```dart
final box = await Hive.openBox<Object?>('settings');
final kv = KvGateway(
  HiveCeKvAdapter(
    box,
    codec: const HiveCeKvCodec(prefix: 'my_app.'),
  ),
);
```

`HiveCeKvAdapter` supports the full local/reactive OmniKV capability set, including read, write, remove, clear, batch, single-key watch, namespace watch, and close.
