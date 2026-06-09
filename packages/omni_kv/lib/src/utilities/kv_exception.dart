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

final class KvMissingValueException extends KvException {
  const KvMissingValueException(String key) : super('No value found for key "$key".');

  @override
  String get name => 'KvMissingValueException';
}

final class KvTypeException extends KvException {
  const KvTypeException(
    super.message, {
    super.cause,
  });

  @override
  String get name => 'KvTypeException';
}

final class KvSerializationException extends KvException {
  const KvSerializationException(
    super.message, {
    super.cause,
  });

  @override
  String get name => 'KvSerializationException';
}

final class KvUnsupportedValueException extends KvException {
  const KvUnsupportedValueException(
    super.message, {
    super.cause,
  });

  @override
  String get name => 'KvUnsupportedValueException';
}
