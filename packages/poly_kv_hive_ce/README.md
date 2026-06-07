# poly_kv_hive_ce

Hive CE adapter for PolyKV.

```dart
final box = await Hive.openBox<Object?>('settings');
final kv = KvGateway(
  HiveCeKvAdapter(
    box,
    codec: const HiveCeKvCodec(prefix: 'my_app.'),
  ),
);
```

When `prefix` is provided, `clear()` only deletes Hive keys that start with that prefix.
