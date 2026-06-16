import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Capability for removing values.
abstract mixin class RemovableKvCapability implements KvCapability {
  Future<void> remove(String key);
}

extension RemovableKvGatewayExtension<A extends RemovableKvCapability> on KvGateway<A> {
  Future<void> remove<T>(KvKey<T> key) => adapter.remove(key.name);
}

extension RemovableKvEntryExtension<T, A extends RemovableKvCapability> on KvEntry<T, A> {
  Future<void> remove() => gateway.remove(key);
}
