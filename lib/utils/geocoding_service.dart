import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeocodingService {
  static Future<Map<String, dynamic>?> getCoordinatesFromAddress(String address) async {
    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      } else {
        print('Error: ${data['status']}');
        return null;
      }
    } else {
      print('Failed to fetch data');
      return null;
    }
  }
}
