sealed class KvException implements Exception {
  const KvException(
    this.message, {
    this.cause,
  });

  final String message;
  final Object? cause;

  @override
  String toString() {
    final cause = this.cause;
    if (cause == null) return '$runtimeType: $message';
    return '$runtimeType: $message\nCaused by: $cause';
  }
}

final class KvMissingValueException extends KvException {
  const KvMissingValueException(String key) : super('No value found for key "$key".');
}

final class KvTypeException extends KvException {
  const KvTypeException(
    super.message, {
    super.cause,
  });
}

final class KvSerializationException extends KvException {
  const KvSerializationException(
    super.message, {
    super.cause,
  });
}

final class KvUnsupportedValueException extends KvException {
  const KvUnsupportedValueException(
    super.message, {
    super.cause,
  });
}
