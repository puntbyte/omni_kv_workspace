import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

void main() {
  group('KvException', () {
    test('KvMissingValueException formats correctly', () {
      const ex = KvMissingValueException('auth_token');
      expect(
        ex.toString(),
        'KvMissingValueException: No value found for key "auth_token".',
      );
    });

    test('preserves cause without owning stack trace state', () {
      final cause = StateError('bad value');
      final ex = KvTypeException(
        'Failed to decode.',
        cause: cause,
      );

      expect(ex.cause, same(cause));
      expect(ex.toString(), contains('Caused by: Bad state: bad value'));
    });
  });
}
