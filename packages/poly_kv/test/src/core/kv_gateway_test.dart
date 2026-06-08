import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

import '../../helpers/app_key_fixture.dart';
import '../../helpers/fake_kv_adapter.dart';

void main() {
  group('KvGateway Capabilities', () {
    late FakeKvAdapter adapter;
    late KvGateway<FakeKvAdapter> gateway;

    setUp(() {
      adapter = FakeKvAdapter();
      gateway = KvGateway(adapter);
    });

    test('read/write/contains via gateway', () async {
      expect(await gateway.contains(AppKey.theme), isFalse);

      // Should read default
      expect(await gateway.read(AppKey.theme), 'dark');

      await gateway.write(AppKey.theme, 'light');
      expect(await gateway.contains(AppKey.theme), isTrue);
      expect(await gateway.read(AppKey.theme), 'light');
    });

    test('remove and clear via gateway', () async {
      await gateway.write(AppKey.theme, 'light');
      await gateway.remove(AppKey.theme);
      expect(await gateway.contains(AppKey.theme), isFalse);

      await gateway.write(AppKey.theme, 'light');
      await gateway.clear();
      expect(adapter.store, isEmpty);
    });

    test('batch via gateway', () async {
      await gateway.batch((entry) async {
        await entry.app(AppKey.theme).write('system');
      });
      expect(await gateway.read(AppKey.theme), 'system');
    });
  });
}
