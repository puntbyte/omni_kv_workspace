abstract interface class KvStorageCodec {
  const KvStorageCodec();

  String storageKey(String logicalKey);

  String logicalKey(Object storageKey);

  bool ownsKey(Object storageKey);

  Object? encode(Object? value);

  Object? decode(Object? value);
}
