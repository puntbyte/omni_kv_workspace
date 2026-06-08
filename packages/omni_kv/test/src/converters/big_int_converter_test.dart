import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

void main() {
  group('BigIntConverter', () {
    test('toString encodes and decodes BigInt correctly', () {
      const converter = BigIntConverter.toString();
      final bigValue = BigInt.parse('9007199254740991000000000');

      final encoded = converter.encode(bigValue);
      expect(encoded, '9007199254740991000000000');

      final decoded = converter.decode(encoded);
      expect(decoded, bigValue);
    });
  });
}
