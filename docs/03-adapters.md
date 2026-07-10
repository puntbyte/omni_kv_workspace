# 3. Adapters

Current adapters:

- `MemoryKvAdapter`
- `HiveCeKvAdapter`
- `SharedPreferencesKvAdapter`
- `SecureStorageKvAdapter`

Decorators:

- `LoggingKvAdapter`
- `CachedKvAdapter`
- `EncryptedKvCodec`

`CachedKvAdapter` requires a full reactive primary adapter and a persistent read/write/clear/batch adapter. Use `flush()` to wait for write-behind operations.
