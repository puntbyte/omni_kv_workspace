import '../core/kv_adapter.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Capability for writing values.
abstract mixin class WritableKvCapability implements KvCapability {
  Future<void> write(String key, Object? value);
}

extension WritableKvGatewayExtension<A extends WritableKvCapability> on KvGateway<A> {
  Future<void> write<T>(KvKey<T> key, T value) {
    return adapter.write(key.name, key.encode(value));
  }

  Future<void> set<T>(KvKey<T> key, T value) => write(key, value);
}

extension WritableKvEntryExtension<T, A extends WritableKvCapability> on KvEntry<T, A> {
  Future<void> write(T value) => gateway.write(key, value);
}
