import 'package:omni_kv/poly_kv.dart';

/// Key/value codec used by `HiveCeKvAdapter`.
///
/// Hive CE can store primitive values directly. This codec mainly owns
/// prefixing and logical/storage key translation so adapter logic stays small.
final class HiveCeKvCodec implements KvStorageCodec {
  const HiveCeKvCodec({this.prefix});

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
        'Hive CE keys managed by PolyKV must be strings.',
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
  Object? encode(Object? value) => value;

  @override
  Object? decode(Object? value) => value;
}
