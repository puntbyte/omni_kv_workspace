# omni_kv_secure_storage

Flutter Secure Storage adapter for OmniKV.

## Usage

```dart
final kv = KvGateway(
  const SecureStorageKvAdapter(
    FlutterSecureStorage(),
    codec: SecureStorageKvCodec(prefix: 'my_app.'),
  ),
);
```

The secure storage codec JSON-encodes values before writing them to secure storage.
