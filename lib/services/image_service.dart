import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final picker = ImagePicker();
  // final FirebaseStorage storage = FirebaseStorage.instance;

  // Function to pick an image
  Future<File?> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Function to upload image and retrieve the download URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
      // Reference ref = storage.ref().child(fileName);

      // // UploadTask uploadTask = ref.putFile(imageFile);
      // await uploadTask;

      // Retrieve the download URL of the uploaded image
      // String downloadUrl = await ref.getDownloadURL();
      // return downloadUrl;
      return fileName;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
