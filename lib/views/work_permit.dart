import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/controller/work_permit_controller.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class WorkPermitPage extends StatelessWidget {
  final workPermitController = Get.put(WorkPermitController());
  WorkPermitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(Strings.workPermit),
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
                      itemCount: workPermitController.workPermitList.length,
                      itemBuilder: (context, index) {
                        final permit =
                            workPermitController.workPermitList[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: permit.verifiedDone
                                ? Colors.green[100]
                                : Colors.red[100],
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
                                            workPermitController
                                                .deletePermit(permit.id);
                                            Navigator.of(context)
                                                .pop(); // Delete the item
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            title: Text(
                                'Work Description: ${permit.workDescription}'),
                            subtitle: Text(
                              'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(permit.date))}',
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  print(jsonEncode(permit));
                                  Get.toNamed(Routes.workPermitForm,
                                      arguments: [
                                        'workpermit',
                                        permit.toJson(),
                                        true
                                      ]);
                                },
                                icon: const Icon(Icons.edit)),
                            onTap: () {
                              // Handle on tap if needed
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    return AlertDialog(
                                      title: const Text('Work Permit Details'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                                'Work Description: ${permit.workDescription}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Date: ${permit.date.toString().split(' ')[0]}'),
                                            const SizedBox(height: 10),
                                            Text('Time: ${permit.time}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Project Name: ${permit.projectName?.projectName ?? ""}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Area: ${permit.area?.siteLocation ?? ""}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Permit Type: ${permit.permitTypes?.permitsType ?? ""}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Tools & Equipment: ${permit.toolsAndEquipment.map((tool) => tool.tools).join(", ")}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Type of Hazard: ${permit.typeOfHazard.map((e) => e.hazards).join(", ")}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Applicable PPEs: ${permit.applicablePPEs.map((e) => e.ppes).join(", ")}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Safety Measures Taken: ${permit.safetyMeasuresTaken}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Verified Done: ${permit.verifiedDone ? "Yes" : "No"}'),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Approval Done: ${permit.approvalDone ? "Yes" : "No"}'),
                                            const SizedBox(height: 10),
                                            Image.network(
                                              permit.undersignDraft,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  });
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
                      onPressed: () {
                        Get.toNamed(
                          Routes.workPermitForm,
                          arguments: ['workpermit', <String, dynamic>{}, false],
                        );
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
