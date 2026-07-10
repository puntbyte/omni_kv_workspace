import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';

/// Adapter contract for reading values.
abstract interface class ReadKvAdapter<TCapability extends ReadKvCapability>
    implements KvAdapter<TCapability> {
  Future<Object?> read(String key);

  Future<bool> contains(String key);
}

extension ReadKvGatewayExtension<TAdapter extends ReadKvAdapter<dynamic>>
    on KvGateway<TAdapter> {
  Future<T> read<T>(KvKey<T> key) async {
    final logicalKey = key.name;
    final hasValue = await adapter.contains(logicalKey);
    final raw = hasValue ? await adapter.read(logicalKey) : null;
    return key.decode(raw, isPresent: hasValue);
  }

  Future<T> get<T>(KvKey<T> key) => read(key);

  Future<bool> contains<T>(KvKey<T> key) => adapter.contains(key.name);
}

extension ReadKvEntryExtension<T, TAdapter extends ReadKvAdapter<dynamic>>
    on KvEntry<T, TAdapter> {
  Future<T> read() => gateway.read(key);

  Future<bool> exists() => gateway.contains(key);
}
