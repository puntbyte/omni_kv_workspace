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