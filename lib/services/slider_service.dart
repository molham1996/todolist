import 'dart:convert';

import 'package:http/http.dart' as http;

class SliderService {
  static Future<bool> deleteById(String id) async {
    final url = 'http://137.184.9.159:5244/api/Sliders/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 204;
  }

  static Future<List?> fetchSlider() async {
    const url = 'http://137.184.9.159:5244/api/Sliders';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateSlider(String id, Map body) async {
    final url = 'http://137.184.9.159:5244/api/Sliders/$id';
    final uri = Uri.parse(url);

    final response = await http.put(uri,
        body: json.encode(body), headers: {"Content-Type": "application/json"});
    return (response.statusCode == 204);
  }

  static Future<bool> addSlider(Map body) async {
    const url = 'http://137.184.9.159:5244/api/Sliders';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: json.encode(body), headers: {"Content-Type": "application/json"});

    return (response.statusCode == 201);
  }
}
