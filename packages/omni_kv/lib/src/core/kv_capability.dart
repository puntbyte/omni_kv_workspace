/// Marker interface for compile-time OmniKV feature sets.
///
/// Capability types describe what a storage adapter can do. They intentionally
/// contain no methods; adapter contracts contain behavior.
abstract interface class KvCapability {}

/// Capability marker for reading keys.
abstract interface class ReadKvCapability implements KvCapability {}

/// Capability marker for writing keys.
abstract interface class WriteKvCapability implements KvCapability {}

/// Capability marker for removing keys.
abstract interface class RemoveKvCapability implements KvCapability {}

/// Capability marker for scoped clearing.
abstract interface class ClearKvCapability implements KvCapability {}

/// Capability marker for watching a single key.
abstract interface class WatchKvCapability implements KvCapability {}

/// Capability marker for watching all keys under a namespace prefix.
abstract interface class NamespaceWatchKvCapability implements WatchKvCapability {}

/// Capability marker for grouped operations.
abstract interface class BatchKvCapability implements KvCapability {}

/// Capability marker for adapters that expose a lifecycle close/dispose hook.
abstract interface class ClosableKvCapability implements KvCapability {}

/// Common read/write/remove capability set.
abstract interface class ReadWriteKvCapability
    implements ReadKvCapability, WriteKvCapability, RemoveKvCapability {}

/// Common non-reactive persistent capability set.
abstract interface class ReadWriteClearBatchKvCapability
    implements
        ReadWriteKvCapability,
        ClearKvCapability,
        BatchKvCapability,
        ClosableKvCapability {}

/// Full local/reactive capability set.
abstract interface class FullKvCapability
    implements
        ReadWriteClearBatchKvCapability,
        WatchKvCapability,
        NamespaceWatchKvCapability {}

/// Capability profile used by the in-memory adapter.
final class MemoryKvCapability implements FullKvCapability {
  const MemoryKvCapability();
}

/// Capability profile used by the cached adapter.
final class CachedKvCapability implements FullKvCapability {
  const CachedKvCapability();
}

/// Capability profile used by the logging decorator.
final class LoggingKvCapability implements FullKvCapability {
  const LoggingKvCapability();
}

/// Capability profile used by the internal batch operation recorder.
final class KvOperationRecorderCapability
    implements WriteKvCapability, RemoveKvCapability {
  const KvOperationRecorderCapability();
}
