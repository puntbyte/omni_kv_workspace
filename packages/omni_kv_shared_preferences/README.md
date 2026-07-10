# omni_kv_shared_preferences

SharedPreferences adapter for OmniKV.

## Usage

```dart
final prefs = await SharedPreferences.getInstance();
final kv = KvGateway(
  SharedPreferencesKvAdapter(
    prefs,
    codec: const SharedPreferencesKvCodec(prefix: 'my_app.'),
  ),
);
```

SharedPreferences supports primitive values. Use `KvConverter`s on keys for complex values.
