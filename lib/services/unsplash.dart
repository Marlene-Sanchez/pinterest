import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pin_model.dart';

class UnsplashService {
  static const String _accessKey = '6dTFsBD3tKyNBwRyd4reg79ER2CIIbU-PIeh7d62yH0';

  Future<List<PinModel>> fetchImages({String query = 'inspiration'}) async {
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

    final data = json.decode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results.map((photo) {
      final item = photo as Map<String, dynamic>;
      final urls = item['urls'] as Map<String, dynamic>;

      return PinModel(
        imageUrl: (urls['small'] as String?) ?? '',
        title: (item['alt_description'] as String?) ?? 'Unsplash image',
        description: (item['description'] as String?) ?? 'Photo from Unsplash',
      );
    }).where((pin) => pin.imageUrl.isNotEmpty).toList();
  }
}