# 5. Troubleshooting

## `clear()` throws `UnsafeClearKvException`

The adapter is unscoped. Configure a codec prefix:

```dart
SharedPreferencesKvAdapter(
  prefs,
  codec: const SharedPreferencesKvCodec(prefix: 'my_app.'),
);
```

Or deliberately opt in:

```dart
await kv.clear(allowUnscoped: true);
```

## Namespaces are not visible in storage

Use `KvKey.name`, not `KvKey.id`, when writing adapter-level operations. OmniKV's gateway does this automatically.
