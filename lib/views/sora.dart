import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/controller/uauc_controller.dart';
import 'package:rohan_suraksha_sathi/helpers/sixed_boxes.dart';
import 'package:rohan_suraksha_sathi/model/uauc_model.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/views/image_view_page.dart';
import 'package:rohan_suraksha_sathi/widgets/helper_widgets/risk_color_switch.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UaucPage extends StatelessWidget {
  UaucPage({super.key});

  final UaucController controller = Get.put(UaucController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => controller.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: "Search UAUC",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          backgroundColor: AppColors.appMainDark,
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
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Open"),
              Tab(text: "Closed"),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            // TabBar

            // TabBarView
            Expanded(
              child: Obx(
                () => Column(
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Select Date or Date Range",
                              content: SizedBox(
                                height: 350, // Give a fixed height
                                width: double
                                    .maxFinite, // Allow it to expand horizontally
                                child: SfDateRangePicker(
                                  showActionButtons: true,
                                  selectionMode:
                                      DateRangePickerSelectionMode.range,
                                  onSubmit: (Object? value) {
                                    if (value is PickerDateRange) {
                                      controller.startDate.value =
                                          value.startDate;
                                      controller.endDate.value = value.endDate;

                                      // Optional: Close dialog or update UI
                                      Get.back();
                                    }
                                  },
                                  onCancel: () {
                                    // Optional: handle cancel action
                                    Get.back();
                                  },
                                ),
                              ),
                            );
                          },
                          child: Text(
                            controller.startDate.value == null ||
                                    controller.endDate.value == null
                                ? "Select Date Range"
                                : "${DateFormat('MMMM d, y').format(controller.startDate.value!)} - ${DateFormat('MMMM d, y').format(controller.endDate.value!)}",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            severityCheckbox(
                                "Critical", Colors.red, controller),
                            severityCheckbox("High", Colors.orange, controller),
                            severityCheckbox(
                                "Medium", Colors.amber, controller),
                            severityCheckbox("Low", Colors.green, controller),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Divider(
                            thickness: 2,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildListView(
                              controller.paginatedWorkPermits), // All
                          _buildListView(controller.paginatedWorkPermits
                              .where((uauc) => uauc.status == "Open")
                              .toList()), // Open
                          _buildListView(controller.paginatedWorkPermits
                              .where((uauc) => uauc.status == "Closed")
                              .toList()), // Closed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (Strings.permisssions.contains("UAUC Creation")) {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: ['uauc', <String, dynamic>{}, false],
              );
              if (result == true) {
                controller.getPermitData();
              }
            } else {
              Get.snackbar("Not Authorized to create UAUC", "");
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Function to build the ListView based on the filtered list
  Widget _buildListView(List<dynamic> uaucList) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.selectedSeverities.clear();
        controller.startDate = Rxn<DateTime>();
        controller.endDate = Rxn<DateTime>();
        await controller.getPermitData();
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: uaucList.length,
              itemBuilder: (context, index) {
                final specificUauc = uaucList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: specificUauc.status == "Open"
                        ? Colors.yellow[100]
                        : Colors.white70,
                    onTap: () {
                      onTapView(context, specificUauc);
                    },
                    onLongPress: () {
                      if (specificUauc.createdby.id == Strings.userId) {
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
                      }
                    },
                    minLeadingWidth: 0,
                    leading: Container(
                      decoration: BoxDecoration(
                        color: getRiskColor(
                            specificUauc.riskValue?.severity ?? ""),
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                      ),
                      width: 3,
                    ),
                    title: Text(
                        '${specificUauc.observation[0].toUpperCase()}${specificUauc.observation.substring(1)}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16)),
                    subtitle: Row(
                      children: [
                        Text(
                          'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(specificUauc.date ?? ""))}',
                        ),
                        const Spacer(),
                        Text(
                          'Time: ${specificUauc.time}',
                        ),
                      ],
                    ),
                    trailing: specificUauc.assignedTo?.id == Strings.userId ||
                            Strings.roleName == "Safety"
                        ? IconButton(
                            onPressed: () async {
                              print(jsonEncode(specificUauc));

                              var result = await Get.toNamed(
                                Routes.formPage,
                                arguments: [
                                  'uauc',
                                  specificUauc.toJson(),
                                  true
                                ],
                              );
                              if (result == true) {
                                controller.getPermitData();
                              }
                            },
                            icon: const Icon(Icons.edit),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: controller.currentPage.value > 0
                    ? () => controller.previousPage()
                    : null,
              ),
              Obx(() => Text("Page ${controller.currentPage.value + 1}")),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: (controller.currentPage.value + 1) *
                            controller.itemsPerPage <
                        uaucList.length
                    ? () => controller.nextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget severityCheckbox(String label, Color color, UaucController controller) {
  return Obx(() {
    final isChecked = controller.selectedSeverities.contains(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: color, // For border when unchecked
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.resolveWith((states) {
                // Always show color background
                if (states.contains(MaterialState.selected)) {
                  return color;
                } else {
                  return color.withOpacity(0.9); // Lighter shade for unchecked
                }
              }),
              checkColor: MaterialStateProperty.all(Colors.white), // Tick color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              side: BorderSide.none, // Removes default border
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: (val) {
              if (val == true) {
                controller.selectedSeverities.add(label);
              } else {
                controller.selectedSeverities.remove(label);
              }
            },
          ),
        ),
        Text(label),
      ],
    );
  });
}

Future<dynamic> onTapView(BuildContext context, UaUc data) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      String imageUrl1 = data.photo ?? "";
      String imageUrl2 = data.actionTakenPhoto ?? "";
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.8, // Limit height to 50% of the screen
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'UAUC Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                    'Project Name:', data.project?.projectName ?? ""),
                _buildDetailRow(
                    'Date:',
                    DateFormat("dd MMM yyyy")
                        .format(DateTime.parse(data.date.toString() ?? ""))),
                _buildDetailRow('Time:', data.time ?? ""),
                _buildDetailRow('Observation:', data.observation ?? ""),
                _buildDetailRow(
                    'Types of Hazards:', data.hazards!.map((e) => e).join(",")),
                _buildDetailRow('Causes', data.causes ?? ""),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      child: Text(
                        "Photo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(ImageViewPage(imageUrl: imageUrl1));
                      },
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(
                            imageUrl1,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildDetailRow('Severity:', data.riskValue?.severity ?? ""),
                _buildDetailRow('Assigned to:', data.assignedTo?.name ?? ""),
                _buildDetailRow('Status:', data.status ?? ""),
                _buildDetailRow(
                    'Geotagging:', data.geotagging ?? "No Location Data"),
                _buildDetailRow(
                    'Corrective Preventive Actions:',
                    data.correctivePreventiveAction ??
                        "No Actions Suggested yet"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      child: Text(
                        "Action Photo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(ImageViewPage(imageUrl: imageUrl2));
                      },
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(
                            imageUrl2,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Column(
                                children: [
                                  Icon(Icons.image_not_supported_rounded),
                                  Text(
                                    "No Image Provided",
                                    style: TextStyle(fontSize: 4),
                                  ),
                                ],
                              ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // _buildDetailRow('Comment:', data ?? ""),
                _buildDetailRow(
                    'Action Taken By:', data.actionTakenBy?.name ?? ""),

                const SizedBox(height: 16),
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
