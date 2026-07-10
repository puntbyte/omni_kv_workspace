import 'dart:async';
import 'dart:io';

final class Print {
  const Print._();

  static void title(String value) {
    stdout
      ..writeln()
      ..writeln('=== $value ===');
  }

  static void section(String value) => title(value);

  static void step(String value) => stdout.writeln('• $value');

  static Future<void> value(String label, FutureOr<Object?> value) async {
    stdout.writeln('  $label: ${await value}');
  }

  static void done(String value) => stdout.writeln('✓ $value');

  static void skip(String value) => stdout.writeln('⏭️ $value');

  static void line() => stdout.writeln('────────────────────────────────────────');
}
