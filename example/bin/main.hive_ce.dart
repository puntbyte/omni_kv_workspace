import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:poly_kv/poly_kv.dart';
import 'package:poly_kv_example/app_keys.dart';
import 'package:poly_kv_hive_ce/poly_kv_hive_ce.dart';

import 'console_output.dart';

Future<void> main() async {
  const output = ConsoleOutput();

  output.title('HiveCeKvAdapter');

  final directory = Directory('.poly_kv_hive_data');
  if (!directory.existsSync()) directory.createSync(recursive: true);

  Hive.init(directory.path);
  final box = await Hive.openBox<Object?>('poly_kv_example');
  final kv = KvGateway(HiveCeKvAdapter(box, prefix: 'example.'));

  final previousCount = await kv.app(AppKey.launchCount).read();
  await kv.app(AppKey.launchCount).write(previousCount + 1);
  await kv.app(AppKey.lastOpenedAt).write(DateTime.now());

  await output.value(
    'Persistent launch count',
    kv.app(AppKey.launchCount).read(),
  );
  await output.value('Last opened', kv.app(AppKey.lastOpenedAt).read());

  await Hive.close();
  output.done('Hive CE demo complete');
}
