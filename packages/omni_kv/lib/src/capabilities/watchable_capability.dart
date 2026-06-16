import '../core/kv_capability.dart';
import '../core/kv_entry.dart';
import '../core/kv_gateway.dart';
import '../core/kv_key.dart';
import '../models/kv_change.dart';

/// Capability for watching value changes.
abstract mixin class WatchableKvCapability implements KvCapability {
  Stream<KvChange<Object?>> watch(String key);
}

extension WatchableKvGatewayExtension<A extends WatchableKvCapability> on KvGateway<A> {
  Stream<KvChange<T>> watch<T>(KvKey<T> key) {
    return adapter.watch(key.id).map((change) {
      final value = change.value == null ? null : key.decode(change.value, isPresent: true);
      final previousValue = change.previousValue == null
          ? null
          : key.decode(change.previousValue, isPresent: true);

      return switch (change) {
        KvRemoveChange<Object?>() => KvRemoveChange<T>(
          key: change.key,
          previousValue: previousValue,
        ),
        _ => KvUpdateChange<T>(
          key: change.key,
          value: value,
          previousValue: previousValue,
        ),
      };
    });
  }
}

extension WatchableKvEntryExtension<T, A extends WatchableKvCapability> on KvEntry<T, A> {
  Stream<KvChange<T>> watch() => gateway.watch(key);
}
