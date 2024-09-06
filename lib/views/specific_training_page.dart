import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:rohan_atmaraksha/controller/specific_training_controller.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class SpecificTrainingPage extends StatelessWidget {
  final controller = Get.put(SpecificTrainingController());
  SpecificTrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text("Specific Training"),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.home_filled),
              onPressed: () {
                Get.offAllNamed(Routes.homePage);
              },
            ),
          ],
          elevation: 2,
        ),
        drawer: const MyDrawer(),
        body: Stack(
          children: [
            Obx(
              () => Column(
                children: [
                  
                   
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.trainingList.length,
                      itemBuilder: (context, index) {
                        final training = controller.trainingList[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            // tileColor: permit.verifiedDone
                            //     ? Colors.green[100]
                            //     : Colors.red[100],
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this item?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Delete'),
                                          onPressed: () async {
                                            controller.deleteSelection(training.id);
                                            Navigator.of(context)
                                                .pop(); // Delete the item
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            title: Text(' Topic: ${training.projectName.projectName}'),
                            subtitle: Text(
                              'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(training.date ?? ""))}',
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  print(jsonEncode(training));
                                  var result = await Get.toNamed(
                                      Routes.formPage,
                                      arguments: [
                                        'specific',
                                        training.toJson(),
                                        true
                                      ]);
                                  if (result == true) {
                                    controller.getPermitData();
                                  }
                                },
                                icon: const Icon(Icons.edit)),
                            onTap: () {
                              // Handle on tap if needed
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () async {
                        var result = await Get.toNamed(
                          Routes.formPage,
                          arguments: ['specific', <String, dynamic>{}, false],
                        );
                        if (result == true) {
                          controller.getPermitData();
                        }
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
