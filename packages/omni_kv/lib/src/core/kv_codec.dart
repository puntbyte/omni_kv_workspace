/// Converts logical OmniKV keys and values to backend-specific storage keys and values.
///
/// Adapter packages implement this contract with backend-specific codecs. The
/// core package owns the shape so adapter behavior stays consistent while
/// concrete codecs remain close to their storage backend.
abstract interface class KvCodec {
  const KvCodec();

  /// Whether this codec is scoped to a specific prefix/keyspace.
  ///
  /// Scoped codecs make destructive operations like clear safer because adapters
  /// can remove only keys owned by this package/application scope.
  bool get isScoped;

  /// Converts a OmniKV logical key into the key used by the storage backend.
  String storageKey(String logicalKey);

  /// Converts a backend key back into a OmniKV logical key.
  String logicalKey(Object? storageKey);

  /// Returns whether this codec owns [storageKey].
  ///
  /// This is mainly used by scoped clear operations so adapters do not remove
  /// keys outside their prefix/scope.
  bool ownsKey(Object? storageKey);

  /// Converts a OmniKV value into a backend-compatible value.
  Object? encode(Object? value);

  /// Converts a backend value into a OmniKV value.
  Object? decode(Object? value);
}
