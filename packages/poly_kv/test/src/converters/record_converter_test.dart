import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

typedef Coords = ({double lat, double lng});

void main() {
  group('RecordConverter', () {
    test('toJsonString handles Dart 3 Records', () {
      final converter = RecordConverter<Coords>.toJsonString(
        toMap: (r) => {'lat': r.lat, 'lng': r.lng},
        fromMap: (json) => (lat: json['lat'] as double, lng: json['lng'] as double),
      );

      const record = (lat: 40.71, lng: -74.0);
      final encoded = converter.encode(record);

      expect(encoded, '{"lat":40.71,"lng":-74.0}');

      final decoded = converter.decode(encoded);
      expect(decoded?.lat, 40.71);
      expect(decoded?.lng, -74.0);
    });
  });
}
