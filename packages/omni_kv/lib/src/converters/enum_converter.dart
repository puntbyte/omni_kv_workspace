import '../core/kv_converter.dart';

sealed class EnumConverter<TEnum extends Enum> implements KvConverter<TEnum?, Object?> {
  const factory EnumConverter.toName(List<TEnum> values) = _EnumNameConverter<TEnum>;

  const factory EnumConverter.toIndex(List<TEnum> values) = _EnumIndexConverter<TEnum>;
}

final class _EnumNameConverter<TEnum extends Enum> implements EnumConverter<TEnum> {
  const _EnumNameConverter(this.values);

  final List<TEnum> values;

  @override
  String? encode(TEnum? value) => value?.name;

  @override
  TEnum? decode(Object? value) {
    if (value == null) return null;
    final name = value as String;
    return values.firstWhere((item) => item.name == name);
  }
}

final class _EnumIndexConverter<TEnum extends Enum> implements EnumConverter<TEnum> {
  const _EnumIndexConverter(this.values);

  final List<TEnum> values;

  @override
  int? encode(TEnum? value) => value?.index;

  @override
  TEnum? decode(Object? value) {
    if (value == null) return null;
    final index = switch (value) {
      final int integer => integer,
      final String string => int.parse(string),
      _ => throw FormatException('Expected enum index, got $value'),
    };
    return values[index];
  }
}
