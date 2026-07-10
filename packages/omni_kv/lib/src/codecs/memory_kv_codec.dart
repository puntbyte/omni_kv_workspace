import '../core/kv_codec.dart';

/// Key/value codec used by `MemoryKvAdapter`.
final class MemoryKvCodec implements KvCodec {
  const MemoryKvCodec({this.prefix});

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
        'Memory keys managed by OmniKV must be strings.',
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
