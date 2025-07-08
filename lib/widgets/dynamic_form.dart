import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/build_radio.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/calculated_field.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/checklist.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/custom_field.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/custom_text_field.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/date_time_fields.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/default_field.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_dropdown.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_extras.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_geotagging.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_image_picker.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_signature_pad.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_simple_multiselect.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/multiselect_field.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/secondary_form.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_simple_dropdown.dart';

import 'dynamic_form/risk_matrix.dart';

class DynamicForm extends StatelessWidget {
  final String pageName;
  final Map<String, dynamic>? initialData;
  final bool isEdit;

  DynamicForm(
      {super.key,
      required this.pageName,
      this.initialData,
      this.isEdit = false});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DynamicFormController controller = Get.find<DynamicFormController>();

  @override
  Widget build(BuildContext context) {
    controller.initializeFormData(initialData);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Form(
              key: _formKey,
              child: Builder(builder: (context) {
                return Obx(
                  () {
                    controller.getPageFields(pageName);

                    return GetBuilder<DynamicFormController>(
                        builder: (controller) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Filter fields based on view permissions and build form fields dynamically for mobile view
                              ...controller.pageFields
                                  .where((field) {
                                    var viewPermissions = List<String>.from(
                                        field.permissions?.view ?? []);
                                    return controller.hasViewPermission(
                                        viewPermissions); // Check if the user has view permission
                                  })
                                  .map((field) => Column(
                                        children: [
                                          // Build the form field dynamically and check for edit permissions
                                          buildFormField(
                                              field,
                                              controller.hasEditPermission(
                                                  field.permissions?.edit ??
                                                      []),
                                              context),
                                          const SizedBox(height: 10),
                                        ],
                                      ))
                                  .toList(),

                              const SizedBox(height: 10),

                              // Submit button
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    if (isEdit) {
                                      controller.updateData(pageName);
                                    } else {
                                      controller.submitForm(pageName);
                                    }
                                  } else {
                                    // Show an error if form is invalid
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please correct the errors in the form'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    isEdit ? 'Update' : 'Submit',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show the CircularProgressIndicator
            } else {
              return SizedBox.shrink(); // Your regular content goes here
            }
          })
        ],
      ),
    );
  }

  Widget buildFormField(
      PageField field, bool isEditable, BuildContext context) {
    switch (field.type) {
      case 'riskMatrix':
        return buildRiskMatrix(field, controller, isEdit);
      case 'customFields':
        return buildCustomFields(controller, pageName);

      case 'defaultField':
        return buildDefaultField(field, controller, isEdit);

      case 'checklist':
        return buildChecklist(field, controller, isEditable);

      case 'CustomTextField':
        return buildCustomTextField(field, controller, isEditable);

      case 'calculatedField':
        return buildCalculatedField(field, controller);

      case 'editablechip':
        return buildEditableChipField(field, controller, isEdit, isEditable);

      case 'multiselect':
        return buildMultiselectField(field, controller, isEditable, context);

      case 'imagepicker':
        return buildImagePickerField(field, controller, isEditable);

      case 'secondaryForm':
        return buildSecondaryFormField(field, controller, isEditable);

      case 'dropdown':
        return buildDropdownField(field, controller, isEditable);

      case 'simplemultiselect':
        return buildSimpleMultiSelect(field, controller, isEditable);

      case 'simpledropdown':
        return buildSimpleDropdown(field, controller);

      case 'datepicker':
        return myDatePicker(field, controller, isEditable);

      case 'timepicker':
        return myTimePicker(field, controller, isEditable);

      case 'radio':
        return buildRadio(field, isEditable, controller);

      case 'switch':
        return buildSwitch(field, controller, isEditable);
      case 'signature':
        return buildSignature(field, controller, isEdit);

      case 'geolocation':
        return buildGeolocation(field, isEditable, controller);

      default:
        return const Text('Unsupported field type');
    }
  }
}
