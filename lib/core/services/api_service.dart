import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/peraturan_response_model.dart';

class ApiService {
  static const String url =
      'https://jdih.nganjukkab.go.id/api';

  static Future<PeraturanResponse> fetchPeraturan() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
        jsonDecode(response.body);

        return PeraturanResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Gagal mengambil data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
