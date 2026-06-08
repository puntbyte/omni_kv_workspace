import 'dart:async';

import '../capabilities/batchable.dart';
import '../capabilities/clearable.dart';
import '../capabilities/readable.dart';
import '../capabilities/removable.dart';
import '../capabilities/watchable.dart';
import '../capabilities/writable.dart';
import '../core/kv_adapter.dart';
import '../models/kv_change.dart';
import 'memory_kv_codec.dart';

final class MemoryKvAdapter
    with SequentialKvBatchCapability
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability,
        ClearableKvCapability,
        WatchableKvCapability,
        BatchableKvCapability {
  MemoryKvAdapter({
    Map<String, Object?>? initialValues,
    this.codec = const MemoryKvCodec(),
  }) : _values = Map<String, Object?>.of(initialValues ?? const {});

  @override
  final MemoryKvCodec codec;
  final Map<String, Object?> _values;
  final Map<String, StreamController<KvChange<Object?>>> _controllers = {};

  Map<String, Object?> get values => Map.unmodifiable(_values);

  @override
  Future<Object?> read(String key) async {
    return codec.decode(_values[codec.storageKey(key)]);
  }

  @override
  Future<bool> contains(String key) async {
    return _values.containsKey(codec.storageKey(key));
  }

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    final storageKey = codec.storageKey(key);
    final previous = _values[storageKey];
    final encoded = codec.encode(value);
    _values[storageKey] = encoded;
    _emit(
      storageKey,
      KvValueChanged<Object?>(
        key: key,
        value: encoded,
        previousValue: previous,
      ),
    );
  }

  @override
  Future<void> remove(String key) async {
    final storageKey = codec.storageKey(key);
    if (!_values.containsKey(storageKey)) return;

    final previous = _values.remove(storageKey);
    _emit(
      storageKey,
      KvValueRemoved<Object?>(
        key: key,
        previousValue: previous,
      ),
    );
  }

  @override
  Future<void> clear() async {
    final keys = _values.keys.where(codec.ownsKey).toList(growable: false);

    for (final key in keys) {
      await remove(codec.logicalKey(key));
    }
  }

  @override
  Stream<KvChange<Object?>> watch(String key) {
    return _controllerFor(codec.storageKey(key)).stream;
  }

  StreamController<KvChange<Object?>> _controllerFor(String storageKey) {
    if (_controllers.containsKey(storageKey)) {
      return _controllers[storageKey]!;
    }

    late final StreamController<KvChange<Object?>> controller;
    controller = StreamController<KvChange<Object?>>.broadcast(
      onCancel: () async {
        // Clean up the controller when there are no more listeners
        if (!controller.hasListener) {
          await controller.close();
          _controllers.remove(storageKey);
        }
      },
    );

    _controllers[storageKey] = controller;
    return controller;
  }

  void _emit(String storageKey, KvChange<Object?> change) {
    final controller = _controllers[storageKey];
    if (controller == null || controller.isClosed) return;
    controller.add(change);
  }
}
