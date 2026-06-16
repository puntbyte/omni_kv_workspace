import 'package:hive_ce/hive.dart';
import 'package:omni_kv/omni_kv.dart';

import 'hive_ce_kv_codec.dart';

final class HiveCeKvAdapter
    with SequentialKvBatchCapability
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability,
        ClearableKvCapability,
        WatchableKvCapability,
        BatchableKvCapability {
  const HiveCeKvAdapter(
    this.box, {
    this.codec = const HiveCeKvCodec(),
  });

  final Box<Object?> box;
  @override
  final HiveCeKvCodec codec;

  @override
  Future<Object?> read(String key) async {
    return codec.decode(box.get(codec.storageKey(key)));
  }

  @override
  Future<bool> contains(String key) async {
    return box.containsKey(codec.storageKey(key));
  }

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }
    await box.put(codec.storageKey(key), codec.encode(value));
  }

  @override
  Future<void> remove(String key) async {
    await box.delete(codec.storageKey(key));
  }

  @override
  Future<void> clear() async {
    final keys = box.keys.where(codec.ownsKey).toList(growable: false);
    await box.deleteAll(keys);
  }

  @override
  Stream<KvChange<Object?>> watch(String key) {
    final storageKey = codec.storageKey(key);

    return box.watch(key: storageKey).map((event) {
      if (event.deleted) {
        return KvRemoveChange<Object?>(
          key: key,
          previousValue: null,
        );
      }

      return KvUpdateChange<Object?>(
        key: key,
        value: codec.decode(event.value),
        previousValue: null,
      );
    });
  }
}
