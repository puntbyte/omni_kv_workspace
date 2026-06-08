import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omni_kv/poly_kv.dart';

import 'secure_storage_kv_codec.dart';

final class SecureStorageKvAdapter
    with SequentialKvBatchCapability
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability,
        ClearableKvCapability,
        BatchableKvCapability {
  const SecureStorageKvAdapter(
    this.storage, {
    this.codec = const SecureStorageKvCodec(),
  });

  final FlutterSecureStorage storage;
  @override
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
    final values = await storage.readAll();
    final keys = values.keys.where(codec.ownsKey).toList(growable: false);

    for (final key in keys) {
      await storage.delete(key: key);
    }
  }
}
