import '../core/kv_converter.dart';

sealed class BigIntConverter implements KvConverter<BigInt?, Object?> {
  const factory BigIntConverter.toString() = _BigIntStringConverter;
}

final class _BigIntStringConverter implements BigIntConverter {
  const _BigIntStringConverter();

  @override
  String? encode(BigInt? value) => value?.toString();

  @override
  BigInt? decode(Object? value) => value == null ? null : BigInt.parse(value as String);
}
