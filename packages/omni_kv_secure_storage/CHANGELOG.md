## [0.1.0]

### Added

- **`SecureStorageKvAdapter`**: A secure OmniKV adapter backed by the `flutter_secure_storage`
  package.
- **`SecureStorageKvCodec`**: Handles logical-to-storage key translation and prefixing.
- Automatically handles JSON encoding and decoding for non-string primitive values.
- Supports capabilities: `Readable`, `Writable`, `Removable`, `Clearable`, and `Batchable`.