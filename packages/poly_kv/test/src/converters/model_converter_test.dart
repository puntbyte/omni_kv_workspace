import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

class Settings {
  Settings(this.darkTheme);

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(map['darkTheme'] as bool);
  final bool darkTheme;

  Map<String, dynamic> toMap() => {'darkTheme': darkTheme};
}

void main() {
  group('ModelConverter', () {
    test('toJsonString encodes/decodes custom classes securely for SharedPreferences', () {
      final converter = ModelConverter<Settings>.toJsonString(
        toMap: (m) => m.toMap(),
        fromMap: Settings.fromMap,
      );

      final settings = Settings(true);
      final encoded = converter.encode(settings);

      expect(encoded, '{"darkTheme":true}');
      expect(converter.decode(encoded)?.darkTheme, isTrue);
    });

    test('toMap encodes/decodes custom classes natively for Hive/Memory', () {
      final converter = ModelConverter<Settings>.toMap(
        toMap: (m) => m.toMap(),
        fromMap: Settings.fromMap,
      );

      final settings = Settings(true);
      final encoded = converter.encode(settings);

      expect(encoded, isA<Map<String, dynamic>>());
      expect((encoded! as Map)['darkTheme'], isTrue);
      expect(converter.decode(encoded)?.darkTheme, isTrue);
    });
  });
}
