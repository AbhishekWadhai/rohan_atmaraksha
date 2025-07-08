import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';

Widget buildChecklist(
    PageField field, DynamicFormController controller, bool isEditable) {
  final List<Map<String, dynamic>> checkListItems = controller.checkList;

  return ExpansionTile(
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    title: Text(field.title),
    children: checkListItems.map((checkPoint) {
      final String checkPointTitle = checkPoint['CheckPoints'] ?? '';
      final String initialResponse = checkPoint['response'] ?? 'No';

      // Save default value if not already present
      controller.formData.update(
        field.headers,
        (existing) {
          final updatedList = List<Map<String, dynamic>>.from(existing);
          final exists =
              updatedList.any((e) => e['CheckPoints'] == checkPointTitle);
          if (!exists) {
            updatedList.add({
              'CheckPoints': checkPointTitle,
              'response': initialResponse,
            });
          }
          return updatedList;
        },
        ifAbsent: () => [
          {
            'CheckPoints': checkPointTitle,
            'response': initialResponse,
          }
        ],
      );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              checkPointTitle,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8.0),
            Obx(() {
              final String currentResponse =
                  controller.formData[field.headers]?.firstWhere(
                        (e) => e['CheckPoints'] == checkPointTitle,
                        orElse: () => {
                          'CheckPoints': checkPointTitle,
                          'response': initialResponse,
                        },
                      )['response'] ??
                      initialResponse;

              return Row(
                children: ['Yes', 'No', 'N/A'].map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: currentResponse,
                        onChanged: isEditable
                            ? (value) {
                                final updatedCheckPoint = {
                                  'CheckPoints': checkPointTitle,
                                  'response': value,
                                };

                                controller.formData.update(
                                  field.headers,
                                  (existing) {
                                    final updatedList =
                                        List<Map<String, dynamic>>.from(
                                            existing);
                                    final index = updatedList.indexWhere((e) =>
                                        e['CheckPoints'] == checkPointTitle);
                                    if (index >= 0) {
                                      updatedList[index] = updatedCheckPoint;
                                    } else {
                                      updatedList.add(updatedCheckPoint);
                                    }
                                    return updatedList;
                                  },
                                  ifAbsent: () => [updatedCheckPoint],
                                );
                              }
                            : null,
                      ),
                      Text(option),
                      const SizedBox(width: 10),
                    ],
                  );
                }).toList(),
              );
            }),
          ],
        ),
      );
    }).toList(),
  );
}
