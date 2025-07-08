import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/services/location_service.dart';

import 'form_extras.dart';

Widget buildGeolocation(
    PageField field, bool isEditable, DynamicFormController controller) {
  return Obx(() {
    String? currentLocation = controller.formData[field.headers];
    double? latitude, longitude;

    RegExp regex = RegExp(r'\(([^,]+),\s*([^)]+)\)');
    Match? match = regex.firstMatch(currentLocation ?? "");

    if (match != null) {
      latitude = double.tryParse(match.group(1)!);
      longitude = double.tryParse(match.group(2)!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (!isEditable)
              return null; // Skip validation for read-only fields
            return controller
                .validateTextField(value); // Validate editable fields
          },
          controller: TextEditingController(
            text: currentLocation,
          ),
          readOnly: true, // Make the field read-only
          decoration: kTextFieldDecoration("Location"),
          onTap: isEditable // Check if it's editable
              ? () async {
                  await controller.fetchGeolocation(field.headers);
                  if (latitude != null && longitude != null) {
                    showGeolocationDialog(
                      latitude: latitude!,
                      longitude: longitude!,
                      onLocationSelected: (LatLng newPosition) {
                        controller.formData[field.headers] =
                            "${newPosition.latitude},${newPosition.longitude}";
                      },
                    );
                  }
                }
              : null, // Disable onTap if not editable
        ),
        // Show a message if not editable
        if (!isEditable)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Location is read-only.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  });
}
