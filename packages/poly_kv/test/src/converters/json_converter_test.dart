import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

void main() {
  group('JsonConverter', () {
    test('toObject encodes and decodes Maps', () {
      const converter = JsonConverter<Map<String, dynamic>>.toObject();
      final map = {'id': 1, 'name': 'Alice'};

      final encoded = converter.encode(map);
      expect(encoded, '{"id":1,"name":"Alice"}');

      final decoded = converter.decode(encoded);
      expect(decoded, map);
    });

    test('toList encodes and decodes Lists', () {
      const converter = JsonConverter<List<dynamic>>.toList();
      final list = [1, 2, 'three'];

      final encoded = converter.encode(list);
      expect(encoded, '[1,2,"three"]');

      final decoded = converter.decode(encoded);
      expect(decoded, list);
    });
  });
}
