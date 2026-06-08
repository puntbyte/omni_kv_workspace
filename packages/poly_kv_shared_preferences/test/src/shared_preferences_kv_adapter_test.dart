import 'package:flutter_test/flutter_test.dart';
import 'package:poly_kv/poly_kv.dart';
import 'package:poly_kv_shared_preferences/poly_kv_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_key_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesKvAdapter', () {
    late SharedPreferences prefs;
    late KvGateway<SharedPreferencesKvAdapter> gateway;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      gateway = KvGateway(SharedPreferencesKvAdapter(prefs));
    });

    test('writes and reads natively supported primitives', () async {
      await gateway.test(.stringVal).write('Hello');
      await gateway.test(.intVal).write(42);
      await gateway.test(.doubleVal).write(3.14);
      await gateway.test(.boolVal).write(true);
      await gateway.test(.listVal).write(['a', 'b']);

      expect(await gateway.test(.stringVal).read(), 'Hello');
      expect(await gateway.test(.intVal).read(), 42);
      expect(await gateway.test(.doubleVal).read(), 3.14);
      expect(await gateway.test(.boolVal).read(), isTrue);
      expect(await gateway.test(.listVal).read(), ['a', 'b']);
    });

    test('throws KvUnsupportedValueException for complex types without converters', () async {
      expect(
        () => gateway.test(.mapVal).write({'key': 'value'}),
        throwsA(isA<KvUnsupportedValueException>()),
      );
    });

    test('batch writes and removes correctly', () async {
      await gateway.test(.stringVal).write('Old');

      await gateway.batch((entry) async {
        await entry.test(.stringVal).remove();
        await entry.test(.intVal).write(99);
      });

      expect(await gateway.test(.stringVal).exists(), isFalse);
      expect(await gateway.test(.intVal).read(), 99);
    });

    test('clear removes all entries', () async {
      await gateway.test(.intVal).write(1);
      await gateway.clear();
      expect(prefs.getKeys(), isEmpty);
    });
  });
}
