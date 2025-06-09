import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/model/work_permit_model.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/location_service.dart';
import 'package:rohan_suraksha_sathi/services/pdf_generator/pdf_generator.dart';
import 'package:rohan_suraksha_sathi/services/translation.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_data_view.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controller/work_permit_controller.dart';

class WorkPermitPage extends StatelessWidget {
  final WorkPermitController workPermitController =
      Get.put(WorkPermitController());

  WorkPermitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => workPermitController.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: "Search Work Permits",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          backgroundColor: AppColors.appMainDark,
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  workPermitController.getPermitData();
                }),
            IconButton(
              icon: const Icon(Icons.home_filled),
              onPressed: () {
                Get.offAllNamed(Routes.homePage);
              },
            ),
          ],
          elevation: 2,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        body: Obx(
          () => Column(
            children: [
              SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 28, // Half the space
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Select Date or Date Range",
                            content: SizedBox(
                              height: 350,
                              width: double.maxFinite,
                              child: SfDateRangePicker(
                                showActionButtons: true,
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                onSubmit: (Object? value) {
                                  if (value is PickerDateRange) {
                                    workPermitController.startDate.value =
                                        value.startDate;
                                    workPermitController.endDate.value =
                                        value.endDate;
                                    Get.back();
                                  }
                                },
                                onCancel: () => Get.back(),
                              ),
                            ),
                          );
                        },
                        child: Obx(() => Text(
                              workPermitController.startDate.value == null ||
                                      workPermitController.endDate.value == null
                                  ? "Select Date Range"
                                  : "${DateFormat('MM/dd').format(workPermitController.startDate.value!)} - ${DateFormat('MM/dd').format(workPermitController.endDate.value!)}",
                              style: const TextStyle(fontSize: 14),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Obx(() => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: workPermitController
                                  .selectedPermitTypeId.value,
                              hint: const Text("Select Permit Type",
                                  style: TextStyle(fontSize: 14)),
                              items:
                                  workPermitController.permitTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type['_id'],
                                  child: Text(type['permitsType'],
                                      style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                workPermitController
                                    .selectedPermitTypeId.value = value;
                                workPermitController.currentPage.value = 0;
                              },
                              underline:
                                  SizedBox(), // Remove extra space under dropdown
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildWorkPermitList(workPermitController
                        .paginatedWorkPermits), // All permits
                    _buildWorkPermitList(workPermitController
                        .paginatedWorkPermits
                        .where((permit) => !permit.verifiedDone)
                        .toList()), // Pending permits
                    _buildWorkPermitList(workPermitController
                        .paginatedWorkPermits
                        .where((permit) => permit.verifiedDone)
                        .toList()), // Completed permits
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (Strings.permisssions.contains("Workpermit Creation")) {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: ['workpermit', <String, dynamic>{}, false],
              );
              if (result == true) {
                workPermitController.getPermitData();
              }
            } else {
              Get.snackbar("Not Authorized to create Workpermit", "");
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildWorkPermitList(List<dynamic> workPermitList) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger the refresh logic
        workPermitController.startDate = Rxn<DateTime>();
        workPermitController.endDate = Rxn<DateTime>();
        workPermitController.selectedPermitTypeId = RxnString();
        await workPermitController.getPermitData();
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: workPermitList.length,
              itemBuilder: (context, index) {
                final permit = workPermitList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4.0, // Adds shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Circular edges
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Circular edges
                    ),
                    tileColor: permit.verifiedDone
                        ? Colors.green[100]
                        : Colors.red[100],
                    onLongPress: () {
                      if (permit.createdby.id == Strings.userId) {
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
                          },
                        );
                      }
                    },
                    title: Text('Type: ${permit.permitTypes.permitsType}'),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Description: ${permit.workDescription}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Text(
                            permit.date != null && permit.date!.isNotEmpty
                                ? DateFormat('dd MM yyyy')
                                    .format(DateTime.parse(permit.date!))
                                : 'Date: -',
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    trailing: permit.createdby?.id == Strings.userId ||
                            permit.verifiedBy
                                .any((item) => item.id == Strings.userId) ||
                            permit.approvalBy
                                .any((item) => item.id == Strings.userId)
                        ? IconButton(
                            onPressed: () async {
                              print(jsonEncode(permit));
                              var result = await Get.toNamed(Routes.formPage,
                                  arguments: [
                                    'workpermit',
                                    permit.toJson(),
                                    true
                                  ]);
                              if (result == true) {
                                workPermitController.getPermitData();
                              }
                            },
                            icon: const Icon(Icons.edit),
                          )
                        : null,
                    onTap: () {
                      onTapView(context, permit);
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: workPermitController.currentPage.value > 0
                    ? () => workPermitController.previousPage()
                    : null,
              ),
              Obx(() =>
                  Text("Page ${workPermitController.currentPage.value + 1}")),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: (workPermitController.currentPage.value + 1) *
                            workPermitController.itemsPerPage <
                        workPermitController.workPermitList.length
                    ? () => workPermitController.nextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> onTapView(BuildContext context, WorkPermit permit) {
  return showModalBottomSheet(
    backgroundColor: AppColors.appMainDark,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return DefaultTabController(
        length: 2,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.8, // Limit height to 50% of the screen
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      const Text(
                        'Work Permit Details',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            saveDynamicDataPdf(permit.toJson(), keysForMap);
                          },
                          icon: Icon(
                            Icons.print,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                //const SizedBox(height: 16),
                const TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.white70,
                  tabs: [
                    Tab(text: "General"),
                    Tab(text: "More"),
                  ],
                ),
                Container(
                  color: Colors.white,
                  height: screenHeight * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TabBarView(children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Work Description:',
                                permit.workDescription ?? ""),
                            _buildDetailRow(
                                'Date:',
                                DateFormat("dd MMM yyyy").format(
                                    DateTime.parse(permit.date.toString()))),
                            _buildDetailRow(
                                'Start Time:', permit.startTime ?? ""),
                            _buildDetailRow('End Time:', permit.endTime ?? ""),
                            _buildDetailRow('Project Name:',
                                permit.project?.projectName ?? ""),
                            _buildDetailRow(
                                'Area:', permit.area?.siteLocation ?? ""),
                            _buildDetailRow('Permit Type:',
                                permit.permitTypes?.permitsType ?? ""),
                            _buildDetailRow(
                                'Tools ',
                                permit.tools
                                        ?.map((tool) => tool.tools)
                                        .join(", ") ??
                                    ""),
                            _buildDetailRow(
                                'Equipments ',
                                permit.equipments
                                        ?.map((equp) => equp.equipments)
                                        .join(", ") ??
                                    ""),
                            _buildDetailRow(
                                'Machine Tools ',
                                permit.machineTools
                                        ?.map((equp) => equp.machineTools)
                                        .join(", ") ??
                                    ""),
                            _buildDetailRow(
                                'Type of Hazard:',
                                permit.typeOfHazard
                                        ?.map((e) => e.hazards)
                                        .join(", ") ??
                                    ""),
                            _buildDetailRow(
                                'Applicable PPEs:',
                                permit.applicablePpEs
                                        ?.map((e) => e.ppes)
                                        .join(", ") ??
                                    ""),
                            _buildDetailRow('Verified Done:',
                                permit.verifiedDone ?? false ? "Yes" : "No"),
                            _buildDetailRow('Approval Done:',
                                permit.approvalDone ?? false ? "Yes" : "No"),
                            ExpansionTile(
                              tilePadding:
                                  EdgeInsets.zero, // Removes default padding
                              title: _buildDetailRow(
                                  'Geolocation', permit.geotagging ?? ""),
                              // subtitle: Text(
                              //     permit.geotagging ?? "No geolocation data"),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: TextButton(
                                    onPressed: () {
                                      if (permit.geotagging != null &&
                                          permit.geotagging!.isNotEmpty) {
                                        var coordinates =
                                            permit.geotagging!.split(',');
                                        double? latitude =
                                            double.tryParse(coordinates[0]);
                                        double? longitude =
                                            double.tryParse(coordinates[1]);

                                        if (latitude != null &&
                                            longitude != null) {
                                          showGeolocationDialog(
                                            latitude: latitude,
                                            longitude: longitude,
                                          );
                                        } else {
                                          Get.snackbar("Error",
                                              "Invalid geolocation data.");
                                        }
                                      } else {
                                        Get.snackbar("Error",
                                            "No geolocation data available.");
                                      }
                                    },
                                    child: const Text("View on Map"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      DynamicDataPage(
                          data: permit.customFields ?? {}, fieldKeys: {})
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Builds a row with evenly spaced title and description
Widget _buildDetailRow(String title, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: Text(
                description,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const Divider()
      ],
    ),
  );
}
