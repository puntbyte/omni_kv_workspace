## [0.2.0]

### Changed

- **KvConverter API tightening:** `KvConverter.decode` now accepts `S?` instead of `Object?`, making
  decoder contracts fully type-safe and aligned with the adapter storage type.
- **InlineKvConverter typing updated:** `InlineKvConverter` now implements `KvConverter<T?, S?>`,
  with `onDecode` updated from `Object?` to `S?` and `encode`/`decode` returning typed nullable
  storage values.
- **Improved type safety:** Removed the need for converter implementations to handle untyped
  storage input, reducing casts and runtime type errors.

### Notes

- Existing built-in and custom converters should be updated to match the new `S?` decode contract.
- This change keeps nullable support intact for both `KvKey<T>` and `KvKey<T?>`.

## [0.1.0]

### Added

- **Core Architecture:** Introduced `KvGateway`, `KvKey`, and `KvEntry` to provide a strongly-typed,
  fluent API for key-value storage.
- **Capability-Based Interfaces:** Added modular capabilities to enforce compile-time safety:
    - `ReadableKvCapability`, `WritableKvCapability`, `RemovableKvCapability`,
      `ClearableKvCapability`, `WatchableKvCapability`, and `BatchableKvCapability`.
- **Built-in Converters:** Added a comprehensive suite of `KvConverter` implementations to
  seamlessly serialize complex types natively or as JSON:
    - `BigIntConverter`, `CollectionConverter`, `DateTimeConverter`, `DurationConverter`,
      `EnumConverter`, `InlineConverter`, `JsonConverter`, `ModelConverter`, `RecordConverter`, and
      `UriConverter`.
- **Memory Storage:** Included `MemoryKvAdapter` and `MemoryKvCodec` out-of-the-box for
  instantaneous, mock-free unit testing and temporary runtime state.
- **Exceptions:** Added custom, descriptive typed exceptions (`KvMissingValueException`,
  `KvTypeException`, `KvSerializationException`, `KvUnsupportedValueException`).
- **Batching System:** Introduced an asynchronous, ordered batching DSL via
  `KvBatchCollectorAdapter` and `SequentialKvBatchCapability`.