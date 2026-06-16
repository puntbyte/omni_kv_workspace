import 'package:omni_kv/src/converters/model_converter.dart';
import 'package:test/test.dart';

class Settings {
  // 1. Make this a required named parameter
  Settings({required this.darkTheme});

  // 2. Update the factory
  factory Settings.fromMap(Map<String, dynamic> map) =>
      Settings(darkTheme: map['darkTheme'] as bool);

  final bool darkTheme;

  Map<String, dynamic> toMap() => {'darkTheme': darkTheme};
}

void main() {
  group('ModelConverter', () {
    test('toJsonString encodes/decodes custom classes securely for SharedPreferences', () {
      final converter = ModelKvConverter<Settings>.toJsonString(
        toMap: (m) => m.toMap(),
        fromMap: Settings.fromMap,
      );

      // 3. Update instantiation
      final settings = Settings(darkTheme: true);
      final encoded = converter.encode(settings);

      expect(encoded, '{"darkTheme":true}');
      expect(converter.decode(encoded)?.darkTheme, isTrue);
    });

    test('toMap encodes/decodes custom classes natively for Hive/Memory', () {
      final converter = ModelKvConverter<Settings>.toMap(
        toMap: (m) => m.toMap(),
        fromMap: Settings.fromMap,
      );

      // 4. Update instantiation
      final settings = Settings(darkTheme: true);
      final encoded = converter.encode(settings);

      expect(encoded, isA<Map<String, dynamic>>());
      expect((encoded! as Map)['darkTheme'], isTrue);
      expect(converter.decode(encoded)?.darkTheme, isTrue);
    });
  });
}
