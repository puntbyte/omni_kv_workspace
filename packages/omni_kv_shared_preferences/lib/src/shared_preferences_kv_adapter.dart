import 'package:omni_kv/omni_kv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_kv_codec.dart';

final class SharedPreferencesKvCapability implements ReadWriteClearBatchKvCapability {
  const SharedPreferencesKvCapability();
}

final class SharedPreferencesKvAdapter
    with SequentialKvBatchAdapter<SharedPreferencesKvCapability>
    implements ReadWriteClearBatchKvAdapter<SharedPreferencesKvCapability> {
  const SharedPreferencesKvAdapter(
    this.preferences, {
    this.codec = const SharedPreferencesKvCodec(),
  });

  final SharedPreferences preferences;

  @override
  final KvCodec codec;

  @override
  Future<Object?> read(String key) async {
    return codec.decode(preferences.get(codec.storageKey(key)));
  }

  @override
  Future<bool> contains(String key) async {
    return preferences.containsKey(codec.storageKey(key));
  }

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    final storageKey = codec.storageKey(key);
    final encoded = codec.encode(value);

    switch (encoded) {
      case final String string:
        await preferences.setString(storageKey, string);
      case final int integer:
        await preferences.setInt(storageKey, integer);
      case final double doubleValue:
        await preferences.setDouble(storageKey, doubleValue);
      case final bool boolean:
        await preferences.setBool(storageKey, boolean);
      case final List<String> strings:
        await preferences.setStringList(storageKey, strings);
      case _:
        throw UnsupportedValueKvException(
          'Unsupported encoded SharedPreferences value: ${encoded.runtimeType}.',
        );
    }
  }

  @override
  Future<void> remove(String key) async {
    await preferences.remove(codec.storageKey(key));
  }

  @override
  Future<void> clear({bool allowUnscoped = false}) async {
    ensureScopedClearAllowed(
      isScoped: codec.isScoped,
      allowUnscoped: allowUnscoped,
      adapterName: 'SharedPreferencesKvAdapter',
    );

    final keys = preferences.getKeys().where(codec.ownsKey).toList(growable: false);
    for (final key in keys) {
      await preferences.remove(key);
    }
  }

  @override
  Future<void> close() async {}
}
