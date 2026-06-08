import 'package:omni_kv/poly_kv.dart';
import 'package:test/test.dart';

extension type UserId(int value) {}

void main() {
  group('InlineConverter', () {
    test('encodes and decodes custom types', () {
      final converter = InlineConverter<UserId, int>(
        onEncode: (id) => id.value,
        onDecode: (val) => UserId(val! as int),
      );

      final encoded = converter.encode(UserId(42));
      expect(encoded, 42);
      expect(converter.decode(encoded)?.value, 42);
    });
  });
}
