import 'package:omni_kv/omni_kv.dart';

enum AppTheme { system, light, dark }

final class AppKey<T> extends KvKey<T> {
  const AppKey(super.name, {required super.defaultValue, super.converter});

  const AppKey.required(super.name, {super.converter}) : super.required();

  static const theme = AppKey<AppTheme>(
    'app.theme',
    defaultValue: AppTheme.system,
    converter: EnumConverter.toName(AppTheme.values),
  );

  static const launchCount = AppKey<int>('app.launch_count', defaultValue: 0);

  static const userName = AppKey<String?>('app.user_name', defaultValue: null);

  static const lastOpenedAt = AppKey<DateTime?>(
    'app.last_opened_at',
    defaultValue: null,
    converter: DateTimeConverter.toIsoString(),
  );

  static const profile = AppKey<Map<String, Object?>?>(
    'app.profile',
    defaultValue: null,
    converter: JsonConverter.toObject(),
  );
}

// Replaces the 4 big scope objects with a single clean method extension!
extension AppKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}
