import 'dart:async';
import 'package:omni_kv/omni_kv.dart';

class FakeKvAdapter
    implements
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability,
        ClearableKvCapability,
        WatchableKvCapability,
        BatchableKvCapability {
  final Map<String, Object?> store = {};
  final StreamController<KvChange<Object?>> controller = StreamController.broadcast();

  @override
  Future<Object?> read(String key) async => store[key];

  @override
  Future<bool> contains(String key) async => store.containsKey(key);

  @override
  Future<void> write(String key, Object? value) async {
    final prev = store[key];
    store[key] = value;
    controller.add(KvValueChanged(key: key, value: value, previousValue: prev));
  }

  @override
  Future<void> remove(String key) async {
    final prev = store.remove(key);
    controller.add(KvValueRemoved(key: key, previousValue: prev));
  }

  @override
  Future<void> clear() async => store.clear();

  @override
  Future<void> batch(List<KvBatchOperation> operations) async {
    for (final operation in operations) {
      switch (operation) {
        case KvBatchWrite(:final key, :final value):
          await write(key, value);
        case KvBatchRemove(:final key):
          await remove(key);
      }
    }
  }

  @override
  Stream<KvChange<Object?>> watch(String key) =>
      controller.stream.where((event) => event.key == key);
}
