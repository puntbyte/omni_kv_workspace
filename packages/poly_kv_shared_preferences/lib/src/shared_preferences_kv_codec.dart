import 'package:poly_kv/poly_kv.dart';

import '../poly_kv_shared_preferences.dart' show SharedPreferencesKvAdapter;

import 'shared_preferences_kv_adapter.dart' show SharedPreferencesKvAdapter;

/// Key/value codec used by [SharedPreferencesKvAdapter].
final class SharedPreferencesKvCodec {
  const SharedPreferencesKvCodec({this.prefix});

  final String? prefix;

  String storageKey(String key) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty) return key;
    return '$prefix$key';
  }

  Object encode(Object value) {
    return switch (value) {
      String() => value,
      int() => value,
      double() => value,
      bool() => value,
      List<String>() => value,
      _ => throw KvUnsupportedValueException(
        'SharedPreferencesKvAdapter natively supports String, int, double, '
        'bool, and List<String>. To store a ${value.runtimeType}, use a '
        'converter on your KvKey.',
      ),
    };
  }

  Object? decode(Object? value) => value;
}
