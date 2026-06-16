import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

enum Status { pending, active }

void main() {
  group('EnumConverter', () {
    test('toName', () {
      const converter = EnumKvConverter.toName(Status.values);
      expect(converter.encode(Status.active), 'active');
      expect(converter.decode('pending'), Status.pending);
    });

    test('toIndex', () {
      const converter = EnumKvConverter.toIndex(Status.values);
      expect(converter.encode(Status.active), 1);
      expect(converter.decode(0), Status.pending);
    });
  });
}
