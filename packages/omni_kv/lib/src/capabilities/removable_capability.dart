import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Adapter contract for removing values.
abstract interface class RemoveKvAdapter<TCapability extends RemoveKvCapability>
    implements KvAdapter<TCapability> {
  Future<void> remove(String key);
}

extension RemoveKvGatewayExtension<TAdapter extends RemoveKvAdapter<dynamic>>
    on KvGateway<TAdapter> {
  Future<void> remove<T>(KvKey<T> key) => adapter.remove(key.name);
}

extension RemoveKvEntryExtension<T, TAdapter extends RemoveKvAdapter<dynamic>>
    on KvEntry<T, TAdapter> {
  Future<void> remove() => gateway.remove(key);
}
