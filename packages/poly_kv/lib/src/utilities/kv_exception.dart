sealed class KvException implements Exception {
  const KvException(this.message);

  final String message;

  @override
  String toString() => 'KvException: $message';
}

final class KvMissingValueException extends KvException {
  const KvMissingValueException(String key) : super('No value found for key "$key".');
}

final class KvTypeException extends KvException {
  const KvTypeException(super.message);
}

final class KvSerializationException extends KvException {
  const KvSerializationException(super.message);
}

final class KvUnsupportedValueException extends KvException {
  const KvUnsupportedValueException(super.message);
}
