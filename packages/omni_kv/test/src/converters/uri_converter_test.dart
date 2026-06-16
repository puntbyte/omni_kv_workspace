import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

void main() {
  group('UriConverter', () {
    test('toString encodes and decodes Uri correctly', () {
      const converter = UriKvConverter.toString();
      final uri = Uri.parse('https://example.com/api?user=1');

      final encoded = converter.encode(uri);
      expect(encoded, 'https://example.com/api?user=1');

      final decoded = converter.decode(encoded);
      expect(decoded, uri);
    });
  });
}
