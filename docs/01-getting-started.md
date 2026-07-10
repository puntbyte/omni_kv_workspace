# 1. Getting started

Define typed keys by extending `KvKey<T>`, then pass a concrete adapter to `KvGateway`.

```dart
final kv = KvGateway(MemoryKvAdapter());
await kv.write(AppKeys.theme, AppTheme.dark);
final theme = await kv.read(AppKeys.theme);
```

Use codec prefixes for persistent stores so `clear()` can safely remove only keys owned by your app.
