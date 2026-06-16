import 'package:omni_kv/omni_kv.dart';

enum AppTheme { system, light, dark }

final class AppKey<T> extends KvKey<T> {
  const AppKey(super.id, {required super.defaultValue, super.converter}) : super(namespace: 'app');

  const AppKey.required(super.id, {super.converter}) : super.required(namespace: 'app');

  static const theme = AppKey<AppTheme>(
    'app.theme',
    defaultValue: AppTheme.system,
    converter: EnumKvConverter.toName(AppTheme.values),
  );

  static const launchCount = AppKey<int>('launch_count', defaultValue: 0);

  static const userName = AppKey<String?>('user_name', defaultValue: null);

  static const lastOpenedAt = AppKey<DateTime?>(
    'last_opened_at',
    defaultValue: null,
    converter: DateTimeKvConverter.toIsoString(),
  );

  static const profile = AppKey<Map<String, Object?>?>(
    'profile',
    defaultValue: null,
    converter: JsonKvConverter.toObject(),
  );
}

// Replaces the 4 big scope objects with a single clean method extension!
extension AppKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}
