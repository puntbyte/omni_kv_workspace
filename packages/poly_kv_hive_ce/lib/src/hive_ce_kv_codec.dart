import 'hive_ce_kv_adapter.dart';

/// Key/value codec used by [HiveCeKvAdapter].
///
/// Hive CE can store the primitive values directly. This codec mainly owns
/// prefixing and logical/storage key translation so adapter logic stays small.
final class HiveCeKvCodec {
  const HiveCeKvCodec({this.prefix});

  final String? prefix;

  String storageKey(String key) {
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty) return key;
    return '$prefix$key';
  }

  String logicalKey(Object key) {
    final storageKey = key as String;
    final prefix = this.prefix;
    if (prefix == null || prefix.isEmpty || !storageKey.startsWith(prefix)) {
      return storageKey;
    }
    return storageKey.substring(prefix.length);
  }

  Object? encode(Object? value) => value;

  Object? decode(Object? value) => value;
}
