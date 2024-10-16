// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart'; // For handling file paths

// class ImageService {
//   final picker = ImagePicker();

//   // Function to pick an image
//   Future<File?> pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//     return null;
//   }

//   // Function to upload image to API and retrieve the URL
//   Future<String?> uploadImage(File imageFile, String endpoint,
//       {String? customFileName}) async {
//     try {
//       // API URL
//       final url = Uri.parse('https://rohan-sage.vercel.app/$endpoint');

//       // Create multipart request
//       var request = http.MultipartRequest('POST', url);

//       // Get the file extension (e.g., .jpg, .png)
//       String fileExtension = extension(imageFile.path);

//       // Use the custom file name if provided, else use the original file name
//       String fileName = customFileName != null
//           ? '$customFileName$fileExtension' // Append the extension to the custom file name
//           : basename(imageFile
//               .path); // Use the original file name if no custom name is provided

//       // Add the image file to the request
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image', // Key for the image file in the form-data
//           imageFile.path,
//           filename: fileName, // Set the custom or original file name
//         ),
//       );

//       // Send the request
//       var response = await request.send();

//       if (response.statusCode == 201) {
//         // Get the response body
//         var responseBody = await http.Response.fromStream(response);

//         // Assuming the API returns the URL of the uploaded image in the response
//         var result = jsonDecode(
//             responseBody.body); // This will be the URL of the uploaded image
//         return result["fileUrl"];
//       } else {
//         print('Failed to upload image. Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'; // For handling file paths

class ImageService {
  final picker = ImagePicker();

  // Function to pick an image from camera or gallery
  Future<File?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        print('No image selected.');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Function to upload image to API and retrieve the URL
  Future<String?> uploadImage(File imageFile, String endpoint,
      {String? customFileName}) async {
    try {
      // API URL
      final url = Uri.parse('https://rohan-sage.vercel.app/$endpoint');

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Get the file extension (e.g., .jpg, .png)
      String fileExtension = extension(imageFile.path);

      // Use the custom file name if provided, else use the original file name
      String fileName = customFileName != null
          ? '$customFileName$fileExtension' // Append the extension to the custom file name
          : basename(imageFile
              .path); // Use the original file name if no custom name is provided

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Key for the image file in the form-data
          imageFile.path,
          filename: fileName, // Set the custom or original file name
        ),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        // Get the response body
        var responseBody = await http.Response.fromStream(response);

        // Parse the response body and extract the URL (assuming API returns a JSON with 'fileUrl')
        var result = jsonDecode(responseBody.body);

        if (result != null && result["fileUrl"] != null) {
          return result["fileUrl"]; // Return the file URL
        } else {
          print('Invalid response format');
          return null;
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
