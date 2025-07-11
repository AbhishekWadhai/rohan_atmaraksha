import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/download_excel.dart';
import 'package:rohan_suraksha_sathi/views/image_view_page.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';
import 'package:rohan_suraksha_sathi/widgets/shimmers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controller/tbt_meeting_controller.dart';

class TBTMeetingPage extends StatelessWidget {
  final TBTMeetingController tbtMeetingController =
      Get.put(TBTMeetingController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => tbtMeetingController.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: "Search TBT Meetings",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          backgroundColor: AppColors.appMainDark,
          actions: [
            if (Strings.roleName == 'Admin' ||
                Strings.roleName == 'Management' ||
                Strings.roleName == 'Project Manager')
              IconButton(
                  icon: const Icon(Icons.file_download_rounded),
                  onPressed: () {
                    showDownloadBottomSheet('meeting');
                  }),
            IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  tbtMeetingController.fetchTBTMeetings();
                }),
            IconButton(
              icon: const Icon(Icons.home_filled),
              onPressed: () {
                Get.offAllNamed("/home"); // Replace with the correct route
              },
            ),
          ],
          elevation: 2,
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Obx(
              () {
                if (tbtMeetingController.isLoading.value) {
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
                return Column(
                  mainAxisSize:
                      MainAxisSize.min, // important to avoid unbounded height
                  children: [
                    Flexible(
                      // instead of Expanded
                      fit: FlexFit.loose,
                      child: TextButton(
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
                                    tbtMeetingController.startDate.value =
                                        value.startDate;
                                    tbtMeetingController.endDate.value =
                                        value.endDate;
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
                          tbtMeetingController.startDate.value == null ||
                                  tbtMeetingController.endDate.value == null
                              ? "Select Date Range"
                              : "${DateFormat('MMMM d, y').format(tbtMeetingController.startDate.value!)} - ${DateFormat('MMMM d, y').format(tbtMeetingController.endDate.value!)}",
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MultiSelectDialogField<String>(
                          items: tbtMeetingController.topics
                              .map((type) => MultiSelectItem<String>(
                                  type['_id'], type['topicTypes']))
                              .toList(),
                          title: const Text("Select Topics"),
                          buttonText: const Text(
                            "Select Topics",
                            style: TextStyle(fontSize: 16),
                          ),
                          initialValue: tbtMeetingController.selectedTopics,
                          onConfirm: (selectedValues) {
                            tbtMeetingController.selectedTopics.value =
                                selectedValues;
                            tbtMeetingController.currentPage.value = 0;
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            textStyle: const TextStyle(fontSize: 14),
                            scroll: true,
                            scrollBar: HorizontalScrollBar(),
                          ),
                          searchable: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: Obx(
                () => _buildMeetingList(
                    tbtMeetingController.paginatedTBTMeetings),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (Strings.permisssions.contains("Safety Creation")) {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: ['meeting', <String, dynamic>{}, false],
              );
              if (result == true) {
                tbtMeetingController.fetchTBTMeetings();
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

  Widget _buildMeetingList(List<dynamic> meetingList) {
    return RefreshIndicator(
      onRefresh: () async {
        tbtMeetingController.startDate = Rxn<DateTime>();
        tbtMeetingController.endDate = Rxn<DateTime>();
        tbtMeetingController.selectedTopics.clear();
        await tbtMeetingController.fetchTBTMeetings();
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: meetingList.length,
              itemBuilder: (context, index) {
                final meeting = meetingList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                      onLongPress: () {
                        if (meeting.createdby.id == Strings.userId) {
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
                                          .pop(); // Close dialog
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () async {
                                      tbtMeetingController
                                          .deleteSelection(meeting.id);
                                      Navigator.of(context)
                                          .pop(); // Delete item
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      title: Text(
                          "Topic: ${meeting.typeOfTopic.map((topic) => topic.topicTypes).join(', ')}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 16)),
                      // Replace with your meeting data
                      subtitle: Row(
                        children: [
                          Text(
                              'Attendees Hrs: ${meeting.attendeesHours.toStringAsFixed(2)}, '),
                          const Spacer(),
                          Text(
                            'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(meeting.date))}',
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle on-tap details view
                        onTapView(context, meeting);
                      },
                      trailing: IconButton(
                          onPressed: () async {
                            print(jsonEncode(meeting));
                            var result = await Get.toNamed(Routes.formPage,
                                arguments: ['meeting', meeting.toJson(), true]);
                            if (result == true) {
                              tbtMeetingController.fetchTBTMeetings();
                            }
                          },
                          icon: const Icon(Icons.edit))),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: tbtMeetingController.currentPage.value > 0
                    ? () => tbtMeetingController.previousPage()
                    : null,
              ),
              Obx(() =>
                  Text("Page ${tbtMeetingController.currentPage.value + 1}")),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: (tbtMeetingController.currentPage.value + 1) *
                            tbtMeetingController.itemsPerPage <
                        tbtMeetingController.tbtMeetingList.length
                    ? () => tbtMeetingController.nextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> onTapView(BuildContext context, dynamic meeting) {
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
      String imageUrl = meeting.documentaryEvidencePhoto ?? "";
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
                // _buildDetailRow('Topic:',
                //     meeting.typeOfTopic.map((e) => e.topicTypes).join(",")),
                _buildDetailRow('Topic:',
                    meeting.typeOfTopic.map((e) => e.topicTypes).join(",")),
                _buildDetailRow(
                    'Date:',
                    DateFormat("dd MMM yyyy")
                        .format(DateTime.parse(meeting.date))),
                _buildDetailRow('Time:', meeting.time),
                _buildDetailRow('Project Name:', meeting.project.projectName),
                _buildDetailRow('Number of Attendees:', meeting.attendeesNos),
                _buildDetailRow(
                    'Attendees Hrs:', meeting.attendeesHours.toString()),
                _buildDetailRow('Attendees:',
                    meeting.attendees.map((e) => e).join(",") ?? ""),
                _buildDetailRow(
                    'TBT Given By:', meeting.tbtGivenBy?.name ?? ""),
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
                _buildDetailRow('Comment Box:', meeting.commentsBox),
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
