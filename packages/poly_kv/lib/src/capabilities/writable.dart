import '../core/kv_adapter.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Adapter capability for writing values.
abstract interface class WritableKvAdapter implements KvAdapter {
  const WritableKvAdapter();

  Future<void> write(String key, Object? value);
}

extension WritableKvGatewayExtension<A extends WritableKvAdapter> on KvGateway<A> {
  Future<void> write<T>(KvKey<T> key, T value) {
    return adapter.write(key.name, key.encode(value));
  }

  Future<void> set<T>(KvKey<T> key, T value) => write(key, value);
}

extension WritableKvEntryExtension<T, A extends WritableKvAdapter> on KvEntry<T, A> {
  Future<void> write(T value) => gateway.write(key, value);
}
