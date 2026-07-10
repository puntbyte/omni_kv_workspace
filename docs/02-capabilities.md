# 2. Capabilities

OmniKV uses marker capabilities and behavior adapters.

Capability examples:

- `ReadKvCapability`
- `WriteKvCapability`
- `WatchKvCapability`
- `BatchKvCapability`
- `FullKvCapability`

Adapter examples:

- `ReadKvAdapter<TCapability>`
- `WriteKvAdapter<TCapability>`
- `FullKvAdapter<TCapability>`

This keeps adapters from being assigned as capabilities while still allowing compile-time extension methods.
