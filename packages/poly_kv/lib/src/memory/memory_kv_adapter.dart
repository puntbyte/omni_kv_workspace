import 'dart:async';

import '../capabilities/batchable.dart';
import '../capabilities/clearable.dart';
import '../capabilities/readable.dart';
import '../capabilities/removable.dart';
import '../capabilities/watchable.dart';
import '../capabilities/writable.dart';
import '../models/kv_batch.dart';
import '../models/kv_change.dart';

final class MemoryKvAdapter
    implements
        ReadableKvAdapter,
        WritableKvAdapter,
        RemovableKvAdapter,
        ClearableKvAdapter,
        WatchableKvAdapter,
        BatchableKvAdapter {
  MemoryKvAdapter({Map<String, Object?>? initialValues, this.prefix})
    : _values = Map<String, Object?>.of(initialValues ?? const {});

  final String? prefix;
  final Map<String, Object?> _values;
  final Map<String, StreamController<KvChange<Object?>>> _controllers = {};

  Map<String, Object?> get values => Map.unmodifiable(_values);

  String _storageKey(String key) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty) return key;
    return '$prefix$key';
  }

  String _logicalKey(String storageKey) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty || !storageKey.startsWith(prefix)) {
      return storageKey;
    }
    return storageKey.substring(prefix.length);
  }

  @override
  Future<Object?> read(String key) async => _values[_storageKey(key)];

  @override
  Future<bool> contains(String key) async => _values.containsKey(_storageKey(key));

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    final storageKey = _storageKey(key);
    final previous = _values[storageKey];
    _values[storageKey] = value;
    _emit(
      storageKey,
      KvValueChanged<Object?>(
        key: key,
        value: value,
        previousValue: previous,
      ),
    );
  }

  @override
  Future<void> remove(String key) async {
    final storageKey = _storageKey(key);
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
    final prefix = this.prefix;
    final keys = prefix == null || prefix.isEmpty
        ? _values.keys.toList(growable: false)
        : _values.keys.where((key) => key.startsWith(prefix)).toList(growable: false);

    for (final key in keys) {
      final logicalKey = _logicalKey(key);
      await remove(logicalKey);
    }
  }

  @override
  Future<void> batch(List<KvRawWrite> writes) async {
    for (final operation in writes) {
      switch (operation) {
        case KvRawSet(:final key, :final value):
          await write(key, value);
        case KvRawRemove(:final key):
          await remove(key);
      }
    }
  }

  @override
  Stream<KvChange<Object?>> watch(String key) {
    return _controllerFor(_storageKey(key)).stream;
  }

  StreamController<KvChange<Object?>> _controllerFor(String storageKey) {
    return _controllers.putIfAbsent(storageKey, StreamController<KvChange<Object?>>.broadcast);
  }

  void _emit(String storageKey, KvChange<Object?> change) {
    final controller = _controllers[storageKey];
    if (controller == null || controller.isClosed) return;
    controller.add(change);
  }
}
