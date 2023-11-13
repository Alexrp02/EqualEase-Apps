import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Prueba de petición a Google', () async {
    var response = await http.get(Uri.parse('https://www.google.com'));
    expect(response.statusCode, 200);
  });
}
