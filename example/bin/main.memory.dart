import 'package:poly_kv/poly_kv.dart';
import 'package:poly_kv_example/app_keys.dart';
import 'package:poly_kv_example/auth_keys.dart';

import 'shared/console_output.dart';

Future<void> main() async {
  ConsoleOutput.title('MemoryKvAdapter');

  final kv = KvGateway(MemoryKvAdapter(prefix: 'example.'));
  final subscription = kv.app(AppKey.theme).watch().listen((change) {
    ConsoleOutput.step('Theme changed: ${change.previousValue} -> ${change.value}');
  });

  await kv.app(AppKey.theme).write(AppTheme.dark);
  await kv.app(AppKey.launchCount).write(1);
  await kv.auth(AuthKey.userProfile).write({'id': 1, 'role': 'admin'});

  await ConsoleOutput.value('Theme', kv.app(AppKey.theme).read());
  await ConsoleOutput.value('Launch count', kv.app(AppKey.launchCount).read());
  await ConsoleOutput.value('Profile', kv.auth(AuthKey.userProfile).read());

  await kv.batch([
    AppKey.theme.set(AppTheme.light),
    AuthKey.token.set('memory-token'),
  ]);

  await ConsoleOutput.value('Token after batch', kv.auth(AuthKey.token).read());

  await subscription.cancel();
  ConsoleOutput.done('Memory demo complete');
}
