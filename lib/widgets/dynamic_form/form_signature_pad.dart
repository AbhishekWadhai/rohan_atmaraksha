import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:signature/signature.dart';

Column buildSignature(
    PageField field, DynamicFormController controller, bool isEdit) {
  String? signatureUrl = controller.formData[field.headers];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),

      isEdit
          ? (signatureUrl != null && signatureUrl.isNotEmpty
              ? Image.network(
                  signatureUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Text("No signature available."))
          : Signature(
              controller: controller.getSignatureController(field.headers),
              height: 200,
              backgroundColor: Colors.grey[200]!,
            ),

      if (!isEdit)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.signatureControllers[field.headers]?.clear();
              },
              child: const Text("Clear"),
            ),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = await controller.saveSignature(
                    field.headers, field.endpoint ?? "");
                if (imageUrl != null) {
                  controller.updateFormData(field.headers, imageUrl);
                  controller.imageErrors[field.headers] = null;
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),

      // Error message display
      Obx(() {
        final error = controller.imageErrors[field.headers];
        return error != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : const SizedBox.shrink();
      }),
    ],
  );
}
