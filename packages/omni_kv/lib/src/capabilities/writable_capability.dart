import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Adapter contract for writing values.
abstract interface class WriteKvAdapter<TCapability extends WriteKvCapability>
    implements KvAdapter<TCapability> {
  Future<void> write(String key, Object? value);
}

extension WriteKvGatewayExtension<TAdapter extends WriteKvAdapter<dynamic>>
    on KvGateway<TAdapter> {
  Future<void> write<T>(KvKey<T> key, T value) {
    return adapter.write(key.name, key.encode(value));
  }

  Future<void> set<T>(KvKey<T> key, T value) => write(key, value);
}

extension WriteKvEntryExtension<T, TAdapter extends WriteKvAdapter<dynamic>>
    on KvEntry<T, TAdapter> {
  Future<void> write(T value) => gateway.write(key, value);
}
