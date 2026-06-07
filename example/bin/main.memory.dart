import 'package:poly_kv/poly_kv.dart';
import 'package:poly_kv_example/app_keys.dart';
import 'package:poly_kv_example/auth_keys.dart';

import 'shared/console_output.dart';

Future<void> main() async {
  ConsoleOutput.title('MemoryKvAdapter');

  final kv = KvGateway(MemoryKvAdapter(prefix: 'example.'));
  final subscription = kv.app(.theme).watch().listen((change) {
    ConsoleOutput.step('Theme changed: ${change.previousValue} -> ${change.value}');
  });

  await kv.app(.theme).write(AppTheme.dark);
  await kv.app(.launchCount).write(1);
  await kv.auth(.userProfile).write({'id': 1, 'role': 'admin'});

  await ConsoleOutput.value('Theme', kv.app(.theme).read());
  await ConsoleOutput.value('Launch count', kv.app(.launchCount).read());
  await ConsoleOutput.value('Profile', kv.auth(.userProfile).read());

  // i do not like it
  await kv.batch([
    AppKey.theme.set(AppTheme.light),
    AuthKey.token.set('memory-token'),
  ]);


  await ConsoleOutput.value('Token after batch', kv.auth(AuthKey.token).read());

  await subscription.cancel();
  ConsoleOutput.done('Memory demo complete');

  await kv.writeAll((entry) {
    entry.app(.theme, AppTheme.light);
    entry.auth(.token, 'memory-token');
  });

  await kv.batch((entry) {
    entry.app(.theme).write(AppTheme.light);
    entry.app(.launchCount).write(2);
    entry.auth(.token).write('memory-token');
    entry.auth(.token).remove();
  });

  await kv.app.batch((entry) {
    entry(.theme).write(AppTheme.light);
    entry(.launchCount).write(2);
  });
}


