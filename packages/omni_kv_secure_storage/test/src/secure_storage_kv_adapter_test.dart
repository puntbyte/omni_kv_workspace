import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_secure_storage/omni_kv_secure_storage.dart';
import 'package:omni_kv_testing/omni_kv_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureStorageKvAdapter', () {
    late KvGateway<SecureStorageKvAdapter> gateway;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      const storage = FlutterSecureStorage();
      gateway = const KvGateway(SecureStorageKvAdapter(storage));
    });

    test('writes and reads strings natively', () async {
      await gateway.test(.token).write('super_secret_string');
      expect(await gateway.test(.token).read(), 'super_secret_string');
    });

    test('automatically JSON encodes/decodes non-string primitives', () async {
      await gateway.test(.pinCode).write(1234);
      expect(await gateway.test(.pinCode).read(), 1234);

      await gateway.test(.metadata).write({'role': 'admin'});
      expect((await gateway.test(.metadata).read())['role'], 'admin');
    });

    test('remove and clear work correctly', () async {
      await gateway.test(.token).write('secret');
      await gateway.test(.token).remove();
      expect(await gateway.test(.token).exists(), isFalse);

      await gateway.test(.pinCode).write(1111);
      await gateway.clear(allowUnscoped: true);
      expect(await gateway.test(.pinCode).exists(), isFalse);
    });

    test('batch performs operations correctly', () async {
      await gateway.test(.token).write('old_token');

      await gateway.batch((entry) async {
        await entry.test(.token).remove();
        await entry.test(.pinCode).write(9999);
      });

      expect(await gateway.test(.token).exists(), isFalse);
      expect(await gateway.test(.pinCode).read(), 9999);
    });
  });
}
