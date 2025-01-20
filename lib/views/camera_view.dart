// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:rohan_suraksha_sathi/services/image_service.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraService _cameraService;
//   late CameraController _controller;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _cameraService = CameraService();
//     _initializeCamera();
//   }

//   // Initialize the camera
//   void _initializeCamera() {
//     _cameraService.initializeCamera();
//     setState(() {
//       _isCameraInitialized = true;
//     });
//   }

//   // Capture image
//   Future<void> _captureImage() async {
//     File? image = await _cameraService.captureImage();
//     if (image != null) {
//       print('Image captured: ${image.path}');
//       // Handle the captured image (e.g., display or upload)
//     } else {
//       print('Error capturing image');
//     }
//   }

//   @override
//   void dispose() {
//     _cameraService
//         .dispose(); // Don't forget to dispose of the camera controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Camera Preview')),
//       body: Column(
//         children: [
//           if (_isCameraInitialized)
//             Expanded(
//               child: CameraPreview(_controller), // Display the live camera feed
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: _captureImage,
//               child: Text('Capture Image'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
