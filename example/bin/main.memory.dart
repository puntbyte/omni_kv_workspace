import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_example/keys/app_keys.dart';
import 'package:omni_kv_example/models/app_theme.dart';
import 'shared/console_output.dart';

Future<void> main() async {
  final output = const ConsoleOutput()..title('Memory + Logging + Namespace Streaming Demo');

  final kv = KvGateway(
    LoggingKvAdapter(
      MemoryKvAdapter(codec: const MemoryKvCodec(prefix: 'demo.')),
      logger: output.step,
    ),
  );

  final sub = kv.watchNamespace('app').listen((change) {
    output.step('🚨 [STREAM] Namespace "app" key changed: ${change.key}');
  });

  await output.value('Dynamic Default Session', kv.app(.sessionStartedAt).read());

  await kv.batch((scope) async {
    await scope.app(.theme).write(AppTheme.dark);
    await scope.app(.volume).write(0.5);
  });

  await Future<void>.delayed(const Duration(milliseconds: 100)); // Let stream print
  await sub.cancel();
  output.done('Memory Demo Complete');
}
