import 'dart:convert';
import 'dart:io'; // Import for File
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:rohan_suraksha_sathi/env.dart'; // Import for basename

class ApiService {
  static String baseUrl = AppEnvironment.baseUrl; // Replace with your base URL

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
  Future<dynamic> postRequest(String endpoint, dynamic data) async {
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
        print("API post successfully: ${response.statusCode}");
        return response.statusCode;
      } else if (response.statusCode == 200) {
        print("API post successfully");
        print(jsonEncode(response.body));
        return jsonDecode(response.body);
      } else {
        print("Failed to post data. Status code: ${json.encode(response)}");
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  // Update method
  Future<int> updateData(
      String endpoint, String id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Data updated successfully: $responseData');
        return response.statusCode;
      } else {
        print('Failed to update data. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error updating data: $e');
      return 0;
    }
  }

  // Common method for making DELETE requests
  Future<dynamic> deleteRequest(String endpoint, String key) async {
    final url = Uri.parse('$baseUrl/$endpoint/$key');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("API delete successfully");
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  // New method for multipart file uploads
  Future<void> uploadFile(
      String endpoint, File file, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      var request = http.MultipartRequest('POST', url);

      // Attach the file
      request.files.add(await http.MultipartFile.fromPath(
        'documentaryEvidencePhoto', // Field name expected by the API
        file.path,
        filename: basename(file.path), // Get the file name
      ));

      // Add other form fields
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("File uploaded successfully.");
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
