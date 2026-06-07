import 'dart:async';
import 'dart:io';

final class ConsoleOutput {
  const ConsoleOutput();

  void title(String value) {
    stdout
      ..writeln()
      ..writeln('=== $value ===');
  }

  void step(String value) {
    stdout.writeln('• $value');
  }

  Future<void> value(String label, FutureOr<Object?> value) async {
    stdout.writeln('$label: ${await value}');
  }

  void done(String value) {
    stdout.writeln('✓ $value');
  }
}
