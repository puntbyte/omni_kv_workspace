## [0.1.0]

### Added

- **`HiveCeKvAdapter`**: A high-performance OmniKV adapter backed by the `hive_ce` package.
- **`HiveCeKvCodec`**: Handles logical-to-storage key translation and prefixing.
- Supports reactive streaming via the `WatchableKvCapability`.
- Supports capabilities: `Readable`, `Writable`, `Removable`, `Clearable`, `Batchable`, and
  `Watchable`.
