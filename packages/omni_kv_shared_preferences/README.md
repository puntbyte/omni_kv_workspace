# poly_kv_shared_preferences

SharedPreferences adapter for PolyKV.

```dart
final prefs = await SharedPreferences.getInstance();
final kv = KvGateway(
  SharedPreferencesKvAdapter(
    prefs,
    codec: const SharedPreferencesKvCodec(prefix: 'my_app.'),
  ),
);
```

Natively supports `String`, `int`, `double`, `bool`, and `List<String>`. Use converters for JSON-like values.

When `prefix` is provided, `clear()` only removes SharedPreferences keys that start with that prefix.
