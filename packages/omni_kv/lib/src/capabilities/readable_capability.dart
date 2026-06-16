import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Capability for reading values.
abstract mixin class ReadableKvCapability implements KvCapability {
  Future<Object?> read(String key);

  Future<bool> contains(String key);
}

extension ReadableKvGatewayExtension<A extends ReadableKvCapability> on KvGateway<A> {
  Future<T> read<T>(KvKey<T> key) async {
    final hasValue = await adapter.contains(key.name);
    final raw = hasValue ? await adapter.read(key.name) : null;
    return key.decode(raw, isPresent: hasValue);
  }

  Future<T> get<T>(KvKey<T> key) => read(key);

  Future<bool> contains<T>(KvKey<T> key) => adapter.contains(key.name);
}

extension ReadableKvEntryExtension<T, A extends ReadableKvCapability> on KvEntry<T, A> {
  Future<T> read() => gateway.read(key);

  Future<bool> exists() => gateway.contains(key);
}
