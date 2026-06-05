import '../core/kv_adapter.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Adapter capability for removing values.
abstract interface class RemovableKvAdapter implements KvAdapter {
  const RemovableKvAdapter();

  Future<void> remove(String key);
}

extension RemovableGatewayExtension<A extends RemovableKvAdapter> on KvGateway<A> {
  Future<void> remove<T>(KvKey<T> key) => adapter.remove(key.name);
}

extension RemovableEntryExtension<T, A extends RemovableKvAdapter> on KvEntry<T, A> {
  Future<void> remove() => gateway.remove(key);
}
