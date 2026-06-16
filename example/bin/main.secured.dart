import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_example/keys/auth_keys.dart';
import 'package:omni_kv_example/models/user_profile.dart';
import 'package:omni_kv_secure_storage/omni_kv_secure_storage.dart';
import 'shared/console_output.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final output = const ConsoleOutput()..title('Secure Storage + Custom Model Console Demo');

  final kv = KvGateway(
    LoggingKvAdapter(
      const SecureStorageKvAdapter(FlutterSecureStorage()),
      logger: output.step,
    ),
  );

  const profile = UserProfile(id: '1', role: 'admin', email: 'admin@omni.kv');

  await kv.batch((scope) async {
    await scope.auth(.profile).write(profile);
    await scope.auth(.lastLogin).write(BigInt.from(DateTime.now().millisecondsSinceEpoch));
  });

  await output.value('Read Profile', kv.auth(.profile).read());

  output.done('Secure Storage Demo Complete');
}
