import 'package:flutter/material.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/widgets/custom_form.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form.dart';

import '../../controller/dynamic_form_contoller.dart';

Widget buildCustomFields(DynamicFormController controller, String pageName) {
  final Map<String, dynamic> customFieldsData = controller.customFields;

  return CustomForm(
    pageFields: controller.additionalFields,
    parentFormController: controller,
    formValues: customFieldsData ?? {},
    reference: pageName,
  );
}

