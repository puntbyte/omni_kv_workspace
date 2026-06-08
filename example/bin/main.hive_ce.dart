import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:omni_kv/poly_kv.dart';
import 'package:omni_kv_example/keys/app_keys.dart';
import 'package:omni_kv_hive_ce/poly_kv_hive_ce.dart';

import 'shared/console_output.dart';

Future<void> main() async {
  final output = const ConsoleOutput()..title('HiveCeKvAdapter');

  final directory = await Directory.systemTemp.createTemp('poly_kv_hive_ce_');
  Hive.init(directory.path);

  final box = await Hive.openBox<Object?>('example');
  final kv = KvGateway(HiveCeKvAdapter(box, codec: const HiveCeKvCodec(prefix: 'example.')));

  await kv.app(.theme).write(AppTheme.dark);
  await kv.app(.launchCount).write(1);

  await kv.batch((entry) async {
    await entry.app(.theme).write(AppTheme.light);
    await entry.app(.launchCount).write(2);
  });

  await output.value('Theme', kv.app(.theme).read());
  await output.value('Launch count', kv.app(.launchCount).read());

  await box.close();
  await directory.delete(recursive: true);

  output.done('Hive CE demo complete');
}
