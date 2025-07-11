import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/controller/safety_report_controller.dart';

import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';
import 'package:rohan_suraksha_sathi/widgets/shimmers.dart';

class IncidentPage extends StatelessWidget {
  final controller = Get.put(SafetyReportController());
  IncidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Safety Report"),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  controller.getPermitData();
                }),
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
        body: Obx(
          () {
            if (controller.isLoading.value) {
              // Show shimmer list while loading
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                    itemCount: 12,
                    itemBuilder: (context, index) => buildShimmerCard(),
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getPermitData();
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.reportList.length,
                      itemBuilder: (context, index) {
                        final report = controller.reportList[index];
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
                            title:
                                Text(' Topic: ${report.project.projectName}'),
                            subtitle: Text(
                              'Date: ${DateFormat('dd MM yyyy').format(report.createdAt)}',
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  // print(jsonEncode(report));

                                  var result = await Get.toNamed(
                                    Routes.formPage,
                                    arguments: [
                                      'safetyreport',
                                      report.toJson(),
                                      true
                                    ],
                                  );
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
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Get.toNamed(
              Routes.formPage,
              arguments: ['safetyreport', <String, dynamic>{}, false],
            );
            if (result == true) {
              controller.getPermitData();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
