import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

void main() {
  group('DurationConverter', () {
    test('toMilliseconds encodes and decodes Duration correctly', () {
      const converter = DurationConverter.toMilliseconds();
      const duration = Duration(hours: 2, minutes: 30);

      final encoded = converter.encode(duration);
      expect(encoded, 9000000); // (2*60*60 + 30*60) * 1000

      final decoded = converter.decode(encoded);
      expect(decoded, duration);
    });
  });
}
