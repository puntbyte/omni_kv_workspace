import 'package:hive_ce/hive.dart';
import 'package:poly_kv/poly_kv.dart';

import 'hive_ce_kv_codec.dart';

final class HiveCeKvAdapter
    implements
        ReadableKvAdapter,
        WritableKvAdapter,
        RemovableKvAdapter,
        ClearableKvAdapter,
        WatchableKvAdapter,
        BatchableKvAdapter {
  const HiveCeKvAdapter(
    this.box, {
    this.codec = const HiveCeKvCodec(),
  });

  final Box<Object?> box;
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
  Future<void> batch(List<KvRawWrite> writes) async {
    final puts = <String, Object?>{};
    final deletes = <String>[];

    for (final write in writes) {
      switch (write) {
        case KvRawSet(:final key, :final value):
          final storageKey = codec.storageKey(key);
          if (value == null) {
            deletes.add(storageKey);
          } else {
            puts[storageKey] = codec.encode(value);
          }
        case KvRawRemove(:final key):
          deletes.add(codec.storageKey(key));
      }
    }

    if (puts.isNotEmpty) await box.putAll(puts);
    if (deletes.isNotEmpty) await box.deleteAll(deletes);
  }

  @override
  Stream<KvChange<Object?>> watch(String key) {
    final storageKey = codec.storageKey(key);

    return box.watch(key: storageKey).map((event) {
      if (event.deleted) {
        return KvValueRemoved<Object?>(
          key: key,
          previousValue: null,
        );
      }

      return KvValueChanged<Object?>(
        key: key,
        value: codec.decode(event.value),
        previousValue: null,
      );
    });
  }
}
