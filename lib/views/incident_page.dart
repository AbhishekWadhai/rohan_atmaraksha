import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_atmaraksha/controller/incident_controller.dart';

import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class IncidentPage extends StatelessWidget {
  final controller = Get.put(IncidentController());
  IncidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text("Incident Report"),
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
                  const TabBar(labelColor: Colors.black, tabs: [
                    Tab(
                      text: "All",
                    ),
                    Tab(
                      text: "Pending",
                    ),
                    Tab(
                      text: "Completed",
                    )
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.incidentList.length,
                      itemBuilder: (context, index) {
                        final meeting = controller.incidentList[index];
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
                                            //controller.deletePermit(permit.id);
                                            Navigator.of(context)
                                                .pop(); // Delete the item
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            title: Text(' Topic: ${meeting.projectName}'),
                            subtitle: Text(
                              'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(meeting.date ?? ""))}',
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  print(jsonEncode(meeting));
                                  var result = await Get.toNamed(
                                      Routes.formPage,
                                      arguments: [
                                        'meeting',
                                        meeting.toJson(),
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
                          arguments: ['meeting', <String, dynamic>{}, false],
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
