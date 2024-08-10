import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://rohan-sage.vercel.app"; // Replace with your base URL

  // Common method for making GET requests
  Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Common method for making POST requests
  Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        print(
            "-----------------------------------${response.statusCode}----------------------------------------------------------");
        print("api post successfully");
        return jsonDecode(response.body);
      } else {
        print(
            "-----------------------------------${response.statusCode}----------------------------------------------------------");
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }
}
