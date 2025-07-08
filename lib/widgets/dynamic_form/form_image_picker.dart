import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/views/image_view_page.dart';

Widget buildImagePickerField(
    PageField field, DynamicFormController controller, bool isEditable) {
  // Initialize with empty string if missing
  controller.formData.putIfAbsent(field.headers, () => "");

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),

      // Upload Button
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: isEditable
                ? () async {
                    await controller.pickAndUploadImage(
                        field.headers, field.endpoint ?? "", "camera");

                    if ((controller.formData[field.headers] ?? "")
                        .toString()
                        .isNotEmpty) {
                      controller.imageErrors[field.headers] = null;
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEditable ? null : Colors.grey,
            ),
            child: const Text('Take Image'),
          ),
          ElevatedButton(
            onPressed: isEditable
                ? () async {
                    await controller.pickAndUploadImage(
                        field.headers, field.endpoint ?? "", "gallery");

                    if ((controller.formData[field.headers] ?? "")
                        .toString()
                        .isNotEmpty) {
                      controller.imageErrors[field.headers] = null;
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEditable ? null : Colors.grey,
            ),
            child: const Text('Gallery'),
          ),
        ],
      ),

      // Image Preview + Error
      Obx(() {
        final imageUrl = controller.formData[field.headers];
        final imageError = controller.imageErrors[field.headers];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (imageUrl is String && imageUrl.isNotEmpty) ...[
              GestureDetector(
                onTap: () => Get.to(ImageViewPage(imageUrl: imageUrl)),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Failed to load image'),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Image uploaded successfully!'),
            ],
            if (imageError != null) ...[
              const SizedBox(height: 8),
              Text(
                imageError,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        );
      }),
    ],
  );
}
