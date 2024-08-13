import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                            title: Text(
                                'Work Description: ${permit.workDescription}'),
                            subtitle: Text(
                                'Date: ${permit.date.toLocal().toString().split(' ')[0]}'),
                            trailing: permit.verifiedDone
                                ? const Icon(Icons.check, color: Colors.green)
                                : const Icon(Icons.close, color: Colors.red),
                            onTap: () {
                              // Handle on tap if needed
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    return AlertDialog(
        title: Text('Work Permit Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Work Description: ${permit.workDescription}'),
              SizedBox(height: 10),
              Text('Date: ${permit.date.toLocal().toString().split(' ')[0]}'),
              SizedBox(height: 10),
              Text('Time: ${permit.time}'),
              SizedBox(height: 10),
              Text('Project Name: ${permit.projectName}'),
              SizedBox(height: 10),
              Text('Area: ${permit.area}'),
              SizedBox(height: 10),
              Text('Permit Type: ${permit.permitTypes}'),
              SizedBox(height: 10),
              Text('Tools & Equipment: ${permit.toolsAndEquipment.join(", ")}'),
              SizedBox(height: 10),
              Text('Type of Hazard: ${permit.typeOfHazard.join(", ")}'),
              SizedBox(height: 10),
              Text('Applicable PPEs: ${permit.applicablePpEs.join(", ")}'),
              SizedBox(height: 10),
              Text('Safety Measures Taken: ${permit.safetyMeasuresTaken}'),
              SizedBox(height: 10),
              Text('Verified Done: ${permit.verifiedDone ? "Yes" : "No"}'),
              SizedBox(height: 10),
              Text('Approval Done: ${permit.approvalDone ? "Yes" : "No"}'),
              SizedBox(height: 10),
              Image.network(
                permit.undersignDraft ?? "",
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
            child: Text('Close'),
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
                        Get.toNamed(Routes.workPermitForm,
                            arguments: {'pageTitle': 'Work Permit'});
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
