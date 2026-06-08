/// A low-level ordered operation collected by the batch DSL and consumed by
/// adapters that implement `BatchableKvCapability`.
sealed class KvBatchOperation {
  const KvBatchOperation(this.key);

  /// Logical PolyKV key. Adapter codecs convert it to a backend storage key.
  final String key;
}

/// Writes [value] to [key].
final class KvBatchWrite extends KvBatchOperation {
  const KvBatchWrite(super.key, this.value);

  /// Encoded value ready for adapter-level storage handling.
  final Object? value;
}

/// Removes [key].
final class KvBatchRemove extends KvBatchOperation {
  const KvBatchRemove(super.key);
}
