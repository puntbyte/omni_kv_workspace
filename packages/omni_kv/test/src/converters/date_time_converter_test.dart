import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeConverter', () {
    final now = DateTime.utc(2026);

    test('toIsoString', () {
      const converter = DateTimeKvConverter.toIsoString();
      final encoded = converter.encode(now);
      expect(encoded, '2026-01-01T00:00:00.000Z');
      expect(converter.decode(encoded)?.isAtSameMomentAs(now), isTrue);
    });

    test('toMilliseconds', () {
      const converter = DateTimeKvConverter.toMilliseconds();
      final encoded = converter.encode(now);
      expect(encoded, now.millisecondsSinceEpoch);
      expect(converter.decode(encoded)?.isAtSameMomentAs(now), isTrue);
    });
  });
}
