import '../core/kv_codec.dart';

/// Wraps a primary [KvCodec] to automatically encrypt data before it reaches the
/// database and decrypt it upon reading.
///
/// Designed to provide fast software encryption for adapters like SharedPreferences
/// and Hive. Expects the underlying encoder to output strings.
final class EncryptedKvCodec implements KvCodec {
  const EncryptedKvCodec({
    required this.delegate,
    required this.onEncrypt,
    required this.onDecrypt,
  });

  /// The primary codec that handles prefixing (e.g. [SharedPreferencesKvCodec]).
  final KvCodec delegate;

  /// Callback to encrypt a stringified payload.
  final String Function(String payload) onEncrypt;

  /// Callback to decrypt a payload.
  final String Function(String payload) onDecrypt;

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

    // Encrypt the string payload before returning it to the adapter.
    return onEncrypt(encodedRaw.toString());
  }

  @override
  Object? decode(Object? value) {
    if (value == null) return null;

    try {
      final decrypted = onDecrypt(value.toString());
      return delegate.decode(decrypted);
    } catch (_) {
      // If decryption fails, gracefully fallback (useful for migrating unencrypted data)
      return delegate.decode(value);
    }
  }
}
