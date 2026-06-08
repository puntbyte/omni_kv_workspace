# poly_kv_secure_storage

Flutter secure storage adapter for PolyKV.

```dart
const storage = FlutterSecureStorage();
const kv = KvGateway(
  SecureStorageKvAdapter(
    storage,
    codec: const SecureStorageKvCodec(prefix: 'my_app.'),
  ),
);
```

The adapter serializes values to strings before writing them to `flutter_secure_storage`. Platform secure-storage behavior is provided by the underlying plugin.

When `prefix` is provided, `clear()` only removes secure-storage keys that start with that prefix.
