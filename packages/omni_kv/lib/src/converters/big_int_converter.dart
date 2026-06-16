import '../core/kv_converter.dart';

final class BigIntKvConverter implements KvConverter<BigInt?, Object?> {
  const BigIntKvConverter.toString();

  @override
  String? encode(BigInt? value) => value?.toString();

  @override
  BigInt? decode(Object? value) => value == null ? null : BigInt.parse(value as String);
}
