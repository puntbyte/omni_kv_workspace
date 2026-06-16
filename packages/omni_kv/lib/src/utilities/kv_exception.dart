sealed class KvException implements Exception {
  const KvException(
    this.message, {
    this.cause,
  });

  final String message;
  final Object? cause;

  /// The name of the exception. Survives Flutter code obfuscation.
  String get name => 'KvException';

  @override
  String toString() {
    final cause = this.cause;
    if (cause == null) return '$name: $message';
    return '$name: $message\nCaused by: $cause';
  }
}

final class MissingValueKvException extends KvException {
  const MissingValueKvException(String key) : super('No value found for key "$key".');

  @override
  String get name => 'MissingValueKvException';
}

final class TypeKvException extends KvException {
  const TypeKvException(
    super.message, {
    super.cause,
  });

  @override
  String get name => 'TypeKvException';
}

final class SerializationKvException extends KvException {
  const SerializationKvException(
    super.message, {
    super.cause,
  });

  @override
  String get name => 'SerializationKvException';
}

final class UnsupportedValueKvException extends KvException {
  const UnsupportedValueKvException(
    super.message, {
    super.cause,
  });

  @override
  String get name => 'UnsupportedValueKvException';
}
