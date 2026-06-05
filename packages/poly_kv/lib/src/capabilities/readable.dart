import '../core/kv_adapter.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Adapter capability for reading values.
abstract interface class ReadableKvAdapter implements KvAdapter {
  const ReadableKvAdapter();

  Future<Object?> read(String key);

  Future<bool> contains(String key);
}

extension ReadableGatewayExtension<A extends ReadableKvAdapter> on KvGateway<A> {
  Future<T> read<T>(KvKey<T> key) async {
    final hasValue = await adapter.contains(key.name);
    final raw = hasValue ? await adapter.read(key.name) : null;
    return key.decode(raw, isPresent: hasValue);
  }

  Future<T> get<T>(KvKey<T> key) => read(key);

  Future<bool> contains<T>(KvKey<T> key) => adapter.contains(key.name);
}

extension ReadableEntry<T, A extends ReadableKvAdapter> on KvEntry<T, A> {
  Future<T> read() => gateway.read(key);
  Future<bool> exists() => gateway.contains(key);
}
