import 'package:flutter/widgets.dart';
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_example/keys/app_keys.dart';
import 'package:omni_kv_example/models/app_theme.dart';
import 'package:omni_kv_shared_preferences/omni_kv_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/console_output.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final output = const ConsoleOutput()..title('Fast Cache + SharedPreferences Console Demo');

  final prefs = await SharedPreferences.getInstance();

  final kv = KvGateway(
    LoggingKvAdapter(
      CachedKvAdapter(
        primary: MemoryKvAdapter(),
        persistent: SharedPreferencesKvAdapter(prefs),
      ),
      logger: output.step,
    ),
  );

  output.step('Because of CachedKvAdapter, SharedPreferences now streams!');
  final sub = kv.app(.theme).watch().listen((c) => output.step('Stream Emitted: ${c.value}'));

  await kv.app(.theme).write(AppTheme.light);
  await Future<void>.delayed(const Duration(milliseconds: 100));

  await sub.cancel();
  output.done('Fast Cache Demo Complete');
}
