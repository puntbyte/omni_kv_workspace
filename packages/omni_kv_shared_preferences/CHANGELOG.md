## [0.1.0]

### Added

- **`SharedPreferencesKvAdapter`**: A fully featured OmniKV adapter backed by the official
  `shared_preferences` package.
- **`SharedPreferencesKvCodec`**: Handles logical-to-storage key translation and prefixing.
- Natively supports `String`, `int`, `double`, `bool`, and `List<String>`.
- Supports capabilities: `Readable`, `Writable`, `Removable`, `Clearable`, and `Batchable`.