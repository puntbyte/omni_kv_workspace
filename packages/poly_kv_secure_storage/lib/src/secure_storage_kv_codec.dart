import 'dart:convert';

import 'package:poly_kv/poly_kv.dart';

/// Key/value codec used by [SecureStorageKvAdapter].
final class SecureStorageKvCodec implements KvStorageCodec {
  const SecureStorageKvCodec({this.prefix});

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
        'Secure storage keys must be strings.',
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
  String encode(Object? value) => jsonEncode(value);

  @override
  Object? decode(Object? value) {
    if (value is! String) return value;

    try {
      return jsonDecode(value);
    } on FormatException {
      return value;
    }
  }
}
