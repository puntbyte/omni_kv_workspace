import 'dart:convert';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_example/keys/auth_keys.dart';
import 'package:omni_kv_hive_ce/omni_kv_hive_ce.dart';
import 'shared/console_output.dart';

Future<void> main() async {
  final output = const ConsoleOutput()..title('Hive CE + Encrypted Codec Demo');

  final dir = await Directory.systemTemp.createTemp('omni_kv_hive_');
  Hive.init(dir.path);
  final box = await Hive.openBox<Object?>('secure_box');

  final kv = KvGateway(
    LoggingKvAdapter(
      HiveCeKvAdapter(
        box,
        codec: EncryptedKvCodec(
          delegate: const HiveCeKvCodec(prefix: 'secure_app.'),
          onEncrypt: (payload) => base64Encode(utf8.encode('AES:$payload')),
          onDecrypt: (payload) => utf8.decode(base64Decode(payload)).replaceAll('AES:', ''),
        ),
      ),
      logger: output.step,
    ),
  );

  await kv.auth(.token).write('super_secret_token');

  output.step('Raw physical database data: ${box.get('secure_app.auth.token')}');
  await output.value('Decrypted token via OmniKV', kv.auth(.token).read());

  await box.close();
  await dir.delete(recursive: true);
  output.done('Hive CE Demo Complete');
}
