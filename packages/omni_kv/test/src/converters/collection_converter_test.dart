import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

enum Role { admin, user }

void main() {
  group('CollectionKvConverter', () {
    test('toList converts elements and restores List', () {
      final converter = CollectionKvConverter.toList(
        const EnumKvConverter.toName(Role.values),
      );

      final list = [Role.admin, Role.user];

      final encoded = converter.encode(list);
      expect(encoded, ['admin', 'user']);

      expect(converter.decode(encoded), list);
    });

    test('toSet converts elements and restores Set', () {
      final converter = CollectionKvConverter.toSet(
        const EnumKvConverter.toName(Role.values),
      );

      final set = {Role.admin, Role.user};

      final encoded = converter.encode(set);
      expect(encoded, ['admin', 'user']); // Stored as a list!

      expect(converter.decode(encoded), set); // Restored as a Set!
    });
  });
}
