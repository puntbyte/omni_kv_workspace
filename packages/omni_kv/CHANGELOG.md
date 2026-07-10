## 0.2.0

- Renamed capability model to `ReadKvCapability`, `WriteKvCapability`, etc.
- Separated marker capabilities from adapter contracts.
- Made `KvAdapter` generic over a capability profile.
- Kept `KvGateway<TAdapter>` ergonomic while preserving compile-time gated APIs.
- Fixed namespace handling by using `KvKey.name` for all gateway operations.
- Added close lifecycle support.
- Added safe clear behavior with `allowUnscoped` opt-in.
- Added `CachedKvWritePolicy`, `flush()`, and write-behind error handling.
- Made `EncryptedKvCodec` plaintext fallback explicit and disabled by default.
- Cleaned OmniKV branding and publishing metadata.

## 0.1.0

- Initial workspace preview.
