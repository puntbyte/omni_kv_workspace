import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

void main() {
  group('KvException', () {
    test('KvMissingValueException formats correctly', () {
      const ex = KvMissingValueException('auth_token');
      expect(ex.toString(), 'KvException: No value found for key "auth_token".');
    });
  });
}
