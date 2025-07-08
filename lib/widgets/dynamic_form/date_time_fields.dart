import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'form_extras.dart';

Widget myDatePicker(
    PageField field, DynamicFormController controller, bool isEditable) {
  // Create a TextEditingController to store and display the picked date
  final TextEditingController dateController = TextEditingController(
    text: controller.formData[field.headers] != null
        ? DateFormat('d-M-yyyy').format(
            DateFormat('yyyy-MM-dd')
                .parse(controller.formData[field.headers].toString()),
          )
        : '', // Provide a fallback value for null, like an empty string
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextFormField(
        validator: (value) {
          if (!isEditable) return null; // Skip validation for read-only fields
          return controller
              .validateTextField(value); // Validate editable fields
        },
        controller: dateController,
        readOnly:
            !isEditable, // Make the TextField read-only based on isEditable
        decoration: kTextFieldDecoration("Select Date",
            suffixIcon: Icon(Icons.calendar_month_rounded)),
        onTap: isEditable // Only show date picker if editable
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 7)),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}"; // Format the date
                  dateController.text = pickedDate
                      .toString(); // Update the TextField with the selected date
                  controller.updateFormData(field.headers,
                      pickedDate.toString()); // Update the form data
                }
              }
            : null, // Disable onTap if not editable
      ),
      // Display the current date if not editable
      if (!isEditable)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            controller.formData[field.headers]?.toString() ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
    ],
  );
}

Widget myTimePicker(
    PageField field, DynamicFormController controller, bool isEditable) {
  // Create a TextEditingController to store and display the selected time
  final TextEditingController timeController = TextEditingController(
    text: controller.formData[field.headers]?.toString() ?? '',
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextFormField(
        validator: (value) {
          if (!isEditable) return null; // Skip validation for read-only fields
          return controller
              .validateTextField(value); // Validate editable fields
        },
        controller: timeController,
        readOnly:
            !isEditable, // Make the TextField read-only based on isEditable
        decoration: kTextFieldDecoration("Select Time",
            suffixIcon: Icon(Icons.access_time_filled_sharp)),
        onTap: isEditable // Only show time picker if editable
            ? () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: Get.context!,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  String formattedTime =
                      selectedTime.format(Get.context!); // Format the time
                  timeController.text =
                      formattedTime; // Update the TextField with the selected time
                  controller.updateFormData(
                      field.headers, formattedTime); // Update the form data
                }
              }
            : null, // Disable onTap if not editable
      ),
      // Display the current time if not editable
      // if (!isEditable)
      //   Padding(
      //     padding: const EdgeInsets.only(top: 8.0),
      //     child: Text(
      //       controller.formData[field.headers] ?? '',
      //       style: const TextStyle(fontSize: 16, color: Colors.grey),
      //     ),
      //   ),
    ],
  );
}
