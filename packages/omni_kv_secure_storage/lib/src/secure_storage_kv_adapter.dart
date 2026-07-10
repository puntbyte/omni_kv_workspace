import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omni_kv/omni_kv.dart';

import 'secure_storage_kv_codec.dart';

final class SecureStorageKvCapability implements ReadWriteClearBatchKvCapability {
  const SecureStorageKvCapability();
}

final class SecureStorageKvAdapter
    with SequentialKvBatchAdapter<SecureStorageKvCapability>
    implements ReadWriteClearBatchKvAdapter<SecureStorageKvCapability> {
  const SecureStorageKvAdapter(
    this.storage, {
    this.codec = const SecureStorageKvCodec(),
  });

  final FlutterSecureStorage storage;

  @override
  final KvCodec codec;

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

    final encoded = codec.encode(value);
    if (encoded is! String) {
      throw UnsupportedValueKvException(
        'SecureStorageKvAdapter requires codecs to encode values as String. '
        'Got ${encoded.runtimeType}.',
      );
    }

    await storage.write(
      key: codec.storageKey(key),
      value: encoded,
    );
  }

  @override
  Future<void> remove(String key) async {
    await storage.delete(key: codec.storageKey(key));
  }

  @override
  Future<void> clear({bool allowUnscoped = false}) async {
    ensureScopedClearAllowed(
      isScoped: codec.isScoped,
      allowUnscoped: allowUnscoped,
      adapterName: 'SecureStorageKvAdapter',
    );

    final values = await storage.readAll();
    final keys = values.keys.where(codec.ownsKey).toList(growable: false);

    for (final key in keys) {
      await storage.delete(key: key);
    }
  }

  @override
  Future<void> close() async {}
}
