// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart'; // For handling file paths
// import 'package:path_provider/path_provider.dart'; // To access temporary directories

// class ImageService {
//   final picker = ImagePicker();

//   // Function to pick an image from camera or gallery
//   Future<File?> pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await picker.pickImage(source: source);
//       if (pickedFile != null) {
//         return File(pickedFile.path);
//       } else {
//         print('No image selected.');
//         return null;
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//       return null;
//     }
//   }

//   // Function to upload image to API and retrieve the URL
//   Future<String?> uploadImage(File image, String endpoint, bool isSignature,
//       {String? customFileName}) async {
//     File? imageFile = isSignature ? image : await compressImage(image);
//     if (imageFile == null) {
//       print("Image compression failed.");
//       return null;
//     }
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

//         // Parse the response body and extract the URL (assuming API returns a JSON with 'fileUrl')
//         var result = jsonDecode(responseBody.body);

//         if (result != null && result["fileUrl"] != null) {
//           return result["fileUrl"]; // Return the file URL
//         } else {
//           print('Invalid response format');
//           return null;
//         }
//       } else {
//         print('Failed to upload image. Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }

//   Future<File?> compressImage(File imageFile) async {
//     try {
//       // Get the temporary directory path
//       final tempDir = await getTemporaryDirectory();
//       final filePath = imageFile.absolute.path;

//       // Define the target path for compressed image
//       final targetPath =
//           '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

//       // Compress the image
//       var compressedImage = await FlutterImageCompress.compressAndGetFile(
//         format: CompressFormat.jpeg,
//         filePath, // Input file path
//         targetPath, // Target file path
//         quality: 70, // Compression quality (1-100, higher is better quality)
//         minWidth: 1080, // Set minimum width (optional)
//         minHeight: 1080, // Set minimum height (optional)
//       );

//       if (compressedImage == null) {
//         print('Compression failed.');
//         return null;
//       }

//       return File(compressedImage.path);
//     } catch (e) {
//       print('Error compressing image: $e');
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:path/path.dart'; // For handling file paths
import 'package:path_provider/path_provider.dart'; // To access temporary directories

class CameraService with ChangeNotifier {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late CameraDescription _camera;
  bool _isInitialized = false;

  // Initialize the camera
  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _camera = _cameras.first; // Select the first available camera

      _controller = CameraController(_camera, ResolutionPreset.medium);
      await _controller.initialize();

      _isInitialized = true;
      notifyListeners(); // Notify listeners when the camera is initialized
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // Function to capture an image
  Future<File?> captureImage() async {
    if (!_isInitialized) {
      print('Camera is not initialized.');
      return null;
    }

    try {
      // Capture image
      final XFile picture = await _controller.takePicture();
      return File(picture.path);
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  // Function to upload image to API and retrieve the URL
  Future<String?> uploadImage(File image, String endpoint, bool isSignature,
      {String? customFileName}) async {
    File? imageFile = isSignature ? image : await compressImage(image);
    if (imageFile == null) {
      print("Image compression failed.");
      return null;
    }

    try {
      // API URL
      final url = Uri.parse('https://rohan-sage.vercel.app/$endpoint');

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Get the file extension (e.g., .jpg, .png)
      String fileExtension = extension(imageFile.path);

      // Use the custom file name if provided, else use the original file name
      String fileName = customFileName != null
          ? '$customFileName$fileExtension'
          : basename(imageFile.path);

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

        // Parse the response body and extract the URL
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

  Future<File?> compressImage(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = imageFile.absolute.path;

      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: 70,
        minWidth: 1080,
        minHeight: 1080,
      );

      if (compressedImage == null) {
        print('Compression failed.');
        return null;
      }

      return File(compressedImage.path);
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Dispose the camera controller
  Future<void> dispose() async {
    await _controller.dispose();
  }

  // Check if the camera is initialized
  bool get isInitialized => _isInitialized;

  // Provide the controller to be used in UI for camera preview
  CameraController get controller => _controller;
}

class CameraPreviewScreen extends StatefulWidget {
  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraService _cameraService;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    try {
      final image = await _cameraService.captureImage();
      if (image != null) {
        // Return the captured image to the calling function
        Get.back(result: image);
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
              children: [
                // Full-screen Camera Preview
                SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_cameraService.controller),
                  ),
                ),
                // Capture button overlay
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      onPressed: _captureImage,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
