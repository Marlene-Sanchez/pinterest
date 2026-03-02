import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _accessKey = '6dTFsBD3tKyNBwRyd4reg79ER2CIIbU-PIeh7d62yH0';

  Future<List<String>> fetchImages({String query = 'inspiration'}) async {
    final url = Uri.parse(
      'https://api.unsplash.com/search/photos'
      '?query=$query'
      '&per_page=30'
      '&client_id=$_accessKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar imágenes');
    }

    final data = json.decode(response.body);
    final results = data['results'] as List;

    return results
        .map((img) => img['urls']['regular'] as String)
        .toList();
  }
}