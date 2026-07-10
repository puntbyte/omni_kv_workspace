# omni_kv

Core OmniKV package.

## Features

- Typed `KvKey<T>` definitions.
- Namespace-aware logical keys using `key.name`.
- Storage codecs for backend key/value translation.
- Converters for enums, dates, durations, JSON, models, records, collections, URIs, and BigInts.
- Capability-gated APIs through adapter contracts.
- Memory adapter.
- Logging, caching, and encryption decorators.
- Safe clear support with explicit `allowUnscoped` opt-in.
- Close lifecycle support.

## Basic usage

```dart
final kv = KvGateway(
  MemoryKvAdapter(codec: const MemoryKvCodec(prefix: 'demo.')),
);

await kv.write(AppKeys.theme, AppTheme.dark);
final theme = await kv.read(AppKeys.theme);
```

## Namespace-aware keys

```dart
final class AppKey<T> extends KvKey<T> {
  const AppKey(super.id, {required super.defaultValue, super.converter})
      : super(namespace: 'app');
}
```

A key with `namespace: 'app'` and `id: 'theme'` has logical name `app.theme`. With a codec prefix of `demo.`, the physical key is `demo.app.theme`.

## Capabilities and adapters

Capabilities are marker types:

```dart
ReadKvCapability
WriteKvCapability
WatchKvCapability
BatchKvCapability
CloseKvCapability
```

Adapters implement behavior contracts:

```dart
ReadKvAdapter<TCapability>
WriteKvAdapter<TCapability>
FullKvAdapter<TCapability>
```

The gateway only carries the adapter type:

```dart
KvGateway<TAdapter extends KvAdapter<dynamic>>
```

## Safe clear

Persistent adapters should be configured with a codec prefix before calling clear:

```dart
final adapter = SharedPreferencesKvAdapter(
  prefs,
  codec: const SharedPreferencesKvCodec(prefix: 'my_app.'),
);

await KvGateway(adapter).clear();
```

To deliberately clear an unscoped adapter:

```dart
await kv.clear(allowUnscoped: true);
```
