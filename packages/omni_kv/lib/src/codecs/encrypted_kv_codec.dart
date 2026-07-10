import '../core/kv_codec.dart';

/// Wraps a primary [KvCodec] to encrypt data before it reaches storage and
/// decrypt it when reading.
///
/// [allowPlaintextFallback] is intentionally false by default. Enable it only
/// for explicit migrations from an unencrypted store.
final class EncryptedKvCodec implements KvCodec {
  const EncryptedKvCodec({
    required this.delegate,
    required this.onEncrypt,
    required this.onDecrypt,
    this.allowPlaintextFallback = false,
  });

  final KvCodec delegate;
  final String Function(String payload) onEncrypt;
  final String Function(String payload) onDecrypt;
  final bool allowPlaintextFallback;

  @override
  bool get isScoped => delegate.isScoped;

  @override
  String storageKey(String logicalKey) => delegate.storageKey(logicalKey);

  @override
  String logicalKey(Object? storageKey) => delegate.logicalKey(storageKey);

  @override
  bool ownsKey(Object? storageKey) => delegate.ownsKey(storageKey);

  @override
  Object? encode(Object? value) {
    if (value == null) return null;
    final encodedRaw = delegate.encode(value);
    if (encodedRaw == null) return null;
    return onEncrypt(encodedRaw.toString());
  }

  @override
  Object? decode(Object? value) {
    if (value == null) return null;

    try {
      return delegate.decode(onDecrypt(value.toString()));
    } catch (_) {
      if (!allowPlaintextFallback) rethrow;
      return delegate.decode(value);
    }
  }
}
