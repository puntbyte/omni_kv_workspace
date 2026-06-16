import '../capabilities/batchable_capability.dart';

/// A low-level storage command collected by the batch DSL and consumed by
/// adapters that implement [BatchableKvCapability].
sealed class KvOperation {
  const KvOperation(this.key);

  /// Logical OmniKV key. Adapter codecs convert it to a backend storage key.
  final String key;
}

/// A command to write [value] to [key].
final class KvWriteOperation extends KvOperation {
  const KvWriteOperation(super.key, this.value);

  /// Encoded value ready for adapter-level storage handling.
  final Object? value;
}

/// A command to remove [key].
final class KvRemoveOperation extends KvOperation {
  const KvRemoveOperation(super.key);
}
