import '../core/kv_key.dart';

// ==============================================================================
// 1. UNTYPED MODELS (Consumed by the Adapter)
// ==============================================================================

sealed class KvRawWrite {
  const KvRawWrite(this.key);
  final String key;
}

final class KvRawSet extends KvRawWrite {
  const KvRawSet(super.key, this.value);
  final Object? value;
}

final class KvRawRemove extends KvRawWrite {
  const KvRawRemove(super.key);
}

// ==============================================================================
// 2. TYPED MODELS (Created by the Developer via the Gateway)
// ==============================================================================

sealed class KvWrite {
  const KvWrite();

  /// Converts the typed write into an untyped write for the adapter.
  KvRawWrite toRaw();
}

final class KvSet<T> extends KvWrite {
  const KvSet(this.key, this.value);
  final KvKey<T> key;
  final T value;

  @override
  KvRawWrite toRaw() => KvRawSet(key.name, key.encode(value));
}

final class KvRemove<T> extends KvWrite {
  const KvRemove(this.key);
  final KvKey<T> key;

  @override
  KvRawWrite toRaw() => KvRawRemove(key.name);
}

// ==============================================================================
// 3. FLUENT EXTENSIONS
// ==============================================================================

extension KvKeyBatchExtension<T> on KvKey<T> {
  /// Fluent helper to create a KvSet operation for a batch.
  KvSet<T> set(T value) => KvSet<T>(this, value);

  /// Fluent helper to create a KvRemove operation for a batch.
  KvRemove<T> remove() => KvRemove<T>(this);
}
