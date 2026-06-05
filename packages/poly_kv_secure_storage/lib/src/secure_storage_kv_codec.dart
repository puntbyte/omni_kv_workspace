import 'dart:convert';

import 'secure_storage_kv_adapter.dart';

/// Key/value codec used by [SecureStorageKvAdapter].
final class SecureStorageKvCodec {
  const SecureStorageKvCodec({this.prefix});

  final String? prefix;

  String storageKey(String key) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty) return key;
    return '$prefix$key';
  }

  String encode(Object? value) => jsonEncode(value);

  Object? decode(String value) {
    try {
      return jsonDecode(value);
    } on FormatException {
      return value;
    }
  }
}
