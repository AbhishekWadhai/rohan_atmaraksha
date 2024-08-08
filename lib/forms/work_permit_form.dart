import 'package:flutter/material.dart';

import 'package:rohan_atmaraksha/widgets/custom_textfield.dart';

class WorkPermitForm extends StatelessWidget {
  WorkPermitForm({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hazardsController = TextEditingController();
  final TextEditingController ppesController = TextEditingController();
  final TextEditingController toolsController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController safetyMeasuresController =
      TextEditingController();
  final TextEditingController formatsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            CustomTextField(
              controller: descriptionController,
              fieldName: "Work Permit Description",
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              fieldName: 'Name of Work Permit',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: hazardsController,
              fieldName: 'Type of Hazards',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: ppesController,
              fieldName: 'Applicable PPEs',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: toolsController,
              fieldName: 'Tools and Equipment',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: areaController,
              fieldName: 'Area of Permission',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: safetyMeasuresController,
              fieldName: 'Safety Measures Taken',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: formatsController,
              fieldName: 'Attached All Formats Copy',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
