import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';

import 'package:rohan_suraksha_sathi/controller/specific_training_controller.dart';
import 'package:rohan_suraksha_sathi/model/secific_training_model.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/download_excel.dart';
import 'package:rohan_suraksha_sathi/views/image_view_page.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';
import 'package:rohan_suraksha_sathi/widgets/shimmers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SpecificTrainingPage extends StatelessWidget {
  final controller = Get.put(SpecificTrainingController());
  SpecificTrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: TextField(
            onChanged: (value) {
              controller.updateSearchQuery(value);
            },
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                hintText: "Search Specific Training",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          backgroundColor: AppColors.appMainDark,
          actions: [
            if (Strings.roleName == 'Admin' ||
                Strings.roleName == 'Management' ||
                Strings.roleName == 'Project Manager')
              IconButton(
                  icon: const Icon(Icons.file_download_rounded),
                  onPressed: () {
                    showDownloadBottomSheet('specific');
                  }),
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
        body: RefreshIndicator(
          onRefresh: () async {
            controller.startDate = Rxn<DateTime>();
            controller.endDate = Rxn<DateTime>();
            controller.selectedTopics.clear();
            await controller.getPermitData();
          },
          child: Column(
            children: [
              Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
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
                                    controller.startDate.value =
                                        value.startDate;
                                    controller.endDate.value = value.endDate;
                                    Get.back();
                                  }
                                },
                                onCancel: () {
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
                      Flexible(
                        child: Obx(() => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: MultiSelectDialogField<String>(
                                items: controller.topics
                                    .map((type) => MultiSelectItem<String>(
                                        type['_id'], type['topicTypes']))
                                    .toList(),
                                title: const Text("Select Topics"),
                                buttonText: const Text(
                                  "Select Topics",
                                  style: TextStyle(fontSize: 16),
                                ),
                                initialValue: controller.selectedTopics,
                                onConfirm: (selectedValues) {
                                  controller.selectedTopics.value =
                                      selectedValues;
                                  controller.currentPage.value = 0;
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(fontSize: 14),
                                  scroll: true,
                                  scrollBar: HorizontalScrollBar(),
                                ),
                                searchable: true,
                              ),
                            )),
                      ),
                    ],
                  )),
              // Training list
              Expanded(
                child: Obx(
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
                    return ListView.builder(
                      itemCount: controller.paginatedTrainingList.length,
                      itemBuilder: (context, index) {
                        final training =
                            controller.paginatedTrainingList[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              onTapView(context, training);
                            },
                            onLongPress: () {
                              if (training.createdby?.id == Strings.userId) {
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
                                            controller
                                                .deleteSelection(training.id);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            title: Text(
                                "Topic: ${training.typeOfTopic?.map((topic) => topic.topicTypes).join(', ') ?? ""}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 16)),
                            subtitle: Text(
                              'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(training.date ?? ""))}',
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                var result = await Get.toNamed(
                                  Routes.formPage,
                                  arguments: [
                                    'specific',
                                    training.toJson(),
                                    true
                                  ],
                                );
                                if (result == true) {
                                  controller.getPermitData();
                                }
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Pagination buttons
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: controller.currentPage.value > 0
                          ? controller.previousPage
                          : null,
                    ),
                    Text(
                      "Page ${controller.currentPage.value + 1}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: ((controller.currentPage.value + 1) *
                                  controller.itemsPerPage <
                              controller.trainingList.length)
                          ? controller.nextPage
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Get.toNamed(
              Routes.formPage,
              arguments: ['specific', <String, dynamic>{}, false],
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

Future<dynamic> onTapView(BuildContext context, SpecificTraining training) {
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
      String imageUrl = training.documentaryEvidencePhoto ?? "";
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
                      'TBT Meeting details Details',
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
                    'Topic:',
                    training.typeOfTopic
                            ?.map((topic) => topic.topicTypes)
                            .join(', ') ??
                        ""),
                _buildDetailRow(
                    'Date:',
                    DateFormat("dd MMM yyyy")
                        .format(DateTime.parse(training.date))),
                _buildDetailRow('Time:', training.time),
                _buildDetailRow(
                    'Project Name:', training.project.projectName ?? ""),
                _buildDetailRow('Attendees Name:',
                    training.attendees?.map((e) => e).join(",") ?? ""),
                _buildDetailRow('Attendees Name:',
                    training.attendeesName?.map((e) => e.name).join(",") ?? ""),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      child: Text(
                        "Document Evidence Photo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(ImageViewPage(imageUrl: imageUrl));
                      },
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(
                            imageUrl,
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
                _buildDetailRow('Comment Box:', training.commentsBox ?? ""),
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
