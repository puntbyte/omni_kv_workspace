import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

void main() {
  group('KvException', () {
    test('MissingValueKvException formats correctly', () {
      const ex = MissingValueKvException('auth_token');
      expect(
        ex.toString(),
        'MissingValueKvException: No value found for key "auth_token".',
      );
    });

    test('preserves cause without owning stack trace state', () {
      final cause = StateError('bad value');
      final ex = TypeKvException(
        'Failed to decode.',
        cause: cause,
      );

      expect(ex.cause, same(cause));
      expect(ex.toString(), contains('Caused by: Bad state: bad value'));
    });
  });
}
