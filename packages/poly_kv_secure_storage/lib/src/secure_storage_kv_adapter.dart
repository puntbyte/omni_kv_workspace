import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:poly_kv/poly_kv.dart';

import 'secure_storage_kv_codec.dart';

final class SecureStorageKvAdapter
    implements
        ReadableKvAdapter,
        WritableKvAdapter,
        RemovableKvAdapter,
        ClearableKvAdapter,
        BatchableKvAdapter {
  SecureStorageKvAdapter(
    this.storage, {
    String? prefix,
  }) : codec = SecureStorageKvCodec(prefix: prefix);

  final FlutterSecureStorage storage;
  final SecureStorageKvCodec codec;

  @override
  Future<Object?> read(String key) async {
    final value = await storage.read(key: codec.storageKey(key));
    if (value == null) return null;
    return codec.decode(value);
  }

  @override
  Future<bool> contains(String key) async {
    return storage.containsKey(key: codec.storageKey(key));
  }

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    await storage.write(
      key: codec.storageKey(key),
      value: codec.encode(value),
    );
  }

  @override
  Future<void> remove(String key) async {
    await storage.delete(key: codec.storageKey(key));
  }

  @override
  Future<void> clear() async {
    final prefix = codec.prefix;
    if (prefix == null || prefix.isEmpty) {
      await storage.deleteAll();
      return;
    }

    final values = await storage.readAll();
    final keys = values.keys.where((key) => key.startsWith(prefix)).toList(growable: false);
    for (final key in keys) {
      await storage.delete(key: key);
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
}
