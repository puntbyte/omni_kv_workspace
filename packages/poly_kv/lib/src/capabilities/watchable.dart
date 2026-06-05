import '../core/kv_adapter.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';
import '../models/kv_change.dart';

/// Adapter capability for watching value changes.
abstract interface class WatchableKvAdapter implements KvAdapter {
  const WatchableKvAdapter();

  Stream<KvChange<Object?>> watch(String key);
}

extension WatchableGatewayExtension<A extends WatchableKvAdapter> on KvGateway<A> {
  Stream<KvChange<T>> watch<T>(KvKey<T> key) {
    return adapter.watch(key.name).map((change) {
      final value = change.value == null ? null : key.decode(change.value, isPresent: true);
      final previousValue = change.previousValue == null
          ? null
          : key.decode(change.previousValue, isPresent: true);

      return switch (change) {
        KvValueRemoved<Object?>() => KvValueRemoved<T>(
          key: change.key,
          previousValue: previousValue,
        ),
        _ => KvValueChanged<T>(
          key: change.key,
          value: value,
          previousValue: previousValue,
        ),
      };
    });
  }
}

extension WatchableEntryExtension<T, A extends WatchableKvAdapter> on KvEntry<T, A> {
  Stream<KvChange<T>> watch() => gateway.watch(key);
}
