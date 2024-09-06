import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_atmaraksha/controller/uauc_controller.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class UaucPage extends StatelessWidget {
  UaucPage({super.key});

  final UaucController controller = Get.put(UaucController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text("UA & UC"),
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
        body: Column(
          children: [
            // TabBar
            const TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(text: "All"),
                Tab(text: "Open"),
                Tab(text: "Closed"),
              ],
            ),
            // TabBarView
            Expanded(
              child: Obx(
                () => TabBarView(
                  children: [
                    _buildListView(_getFilteredUaucList()), // All
                    _buildListView(_getFilteredUaucList(status: "Open")), // Pending
                    _buildListView(_getFilteredUaucList(status: "Closed")), // Completed
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Get.toNamed(
              Routes.formPage,
              arguments: ['uauc', <String, dynamic>{}, false],
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

  // Function to filter the uaucList based on the status
  List<dynamic> _getFilteredUaucList({String? status}) {
    if (status == null) {
      return controller.uaucList; // All items
    } else {
      return controller.uaucList.where((uauc) => uauc.status == status).toList();
    }
  }

  // Function to build the ListView based on the filtered list
  Widget _buildListView(List<dynamic> uaucList) {
    return ListView.builder(
      itemCount: uaucList.length,
      itemBuilder: (context, index) {
        final specificUauc = uaucList[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            tileColor: specificUauc.status == "Open"
                ? Colors.yellow[100]
                : Colors.white70,
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this item?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () async {
                          controller.deleteSelection(specificUauc.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            title: Text(
              'Project Name: ${specificUauc.projectName.projectName}',
            ),
            subtitle: Text(
              'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(specificUauc.date ?? ""))}',
            ),
            trailing: IconButton(
              onPressed: () async {
                print(jsonEncode(specificUauc));
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: ['uauc', specificUauc.toJson(), true],
                );
                if (result == true) {
                  controller.getPermitData();
                }
              },
              icon: const Icon(Icons.edit),
            ),
            onTap: () {
              // Handle on tap if needed
            },
          ),
        );
      },
    );
  }
}
