import 'package:poly_kv/poly_kv.dart';
import 'package:poly_kv_example/keys/app_keys.dart';
import 'package:poly_kv_example/keys/auth_keys.dart';

import 'shared/console_output.dart';

Future<void> main() async {
  const output = ConsoleOutput();

  output.title('MemoryKvAdapter');

  final kv = KvGateway(
    MemoryKvAdapter(
      codec: const MemoryKvCodec(prefix: 'example.'),
    ),
  );
  final subscription = kv.app(.theme).watch().listen((change) {
    output.step('Theme changed: ${change.previousValue} -> ${change.value}');
  });

  await kv.app(.theme).write(AppTheme.dark);
  await kv.app(.launchCount).write(1);
  await kv.auth(.userProfile).write({'id': 1, 'role': 'admin'});

  await output.value('Theme', kv.app(.theme).read());
  await output.value('Launch count', kv.app(.launchCount).read());
  await output.value('Profile', kv.auth(.userProfile).read());

  await kv.batch((entry) {
    entry.app(.theme).write(AppTheme.light);
    entry.app(.launchCount).write(2);
    entry.auth(.token).write('memory-token');
    entry.auth(.token).remove();
  });

  await output.value('Theme after batch', kv.app(.theme).read());
  await output.value('Token after batch', kv.auth(.token).read());

  await kv.app.batch((entry) {
    entry(.theme).write(AppTheme.dark);
    entry(.launchCount).write(3);
  });

  await output.value('Theme after app batch', kv.app(.theme).read());
  await output.value('Launch count after app batch', kv.app(.launchCount).read());

  await subscription.cancel();
  output.done('Memory demo complete');
}
