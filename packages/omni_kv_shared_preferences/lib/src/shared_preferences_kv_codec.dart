import 'package:omni_kv/omni_kv.dart';

/// Key/value codec used by `SharedPreferencesKvAdapter`.
final class SharedPreferencesKvCodec implements KvCodec {
  const SharedPreferencesKvCodec({this.prefix});

  final String? prefix;

  @override
  String storageKey(String logicalKey) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty) return logicalKey;
    return '$prefix$logicalKey';
  }

  @override
  String logicalKey(Object? storageKey) {
    if (storageKey is! String) {
      throw ArgumentError.value(
        storageKey,
        'storageKey',
        'SharedPreferences keys must be strings.',
      );
    }

    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty || !storageKey.startsWith(prefix)) {
      return storageKey;
    }

    return storageKey.substring(prefix.length);
  }

  @override
  bool ownsKey(Object? storageKey) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty) return true;

    return storageKey is String && storageKey.startsWith(prefix);
  }

  @override
  Object? encode(Object? value) {
    return switch (value) {
      String() => value,
      int() => value,
      double() => value,
      bool() => value,
      List<String>() => value,
      _ => throw UnsupportedValueKvException(
        'SharedPreferencesKvAdapter natively supports String, int, double, '
        'bool, and List<String>. To store a ${value.runtimeType}, use a '
        'converter on your KvKey.',
      ),
    };
  }

  @override
  Object? decode(Object? value) => value;
}
