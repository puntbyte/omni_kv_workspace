import 'package:omni_kv/omni_kv.dart';

/// Key/value codec used by `HiveCeKvAdapter`.
final class HiveCeKvCodec implements KvCodec {
  const HiveCeKvCodec({this.prefix});

  final String? prefix;

  bool get isScoped => prefix != null && prefix!.isNotEmpty;

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
        'Hive CE keys managed by OmniKV must be strings.',
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
