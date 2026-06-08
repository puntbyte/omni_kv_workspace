import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

void main() {
  group('KvKey', () {
    test('returns default value when not present in storage', () {
      const key = KvKey<int>('age', defaultValue: 18);
      expect(key.decode(null, isPresent: false), 18);
    });

    test('throws KvMissingValueException when required and missing', () {
      const key = KvKey<String>.required('token');
      expect(
        () => key.decode(null, isPresent: false),
        throwsA(isA<KvMissingValueException>()),
      );
    });

    test('returns null when present but stored value is null', () {
      const key = KvKey<String?>('bio', defaultValue: null);
      expect(key.decode(null, isPresent: true), isNull);
    });
  });
}
