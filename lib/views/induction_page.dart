import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/controller/safety_induction_controller.dart';
import 'package:rohan_suraksha_sathi/model/induction_model.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/views/image_view_page.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';

class InductionPage extends StatelessWidget {
  InductionPage({super.key});
  final controller = Get.put(SafetyInductionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: TextField(
          onChanged: (value) => controller.updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: "Search Inductions",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
        backgroundColor: Colors.white,
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
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getPermitData();
        },
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.paginatedInductions.length,
                  itemBuilder: (context, index) {
                    final induction = controller.paginatedInductions[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onLongPress: () {
                          if (induction.createdby.id == Strings.userId) {
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
                                        controller
                                            .deleteSelection(induction.id);
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
                            'Topic: ${induction.typeOfTopic.topicTypes ?? ""}'),
                        subtitle: Text(
                          'Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(induction.date ?? ""))}',
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            print(jsonEncode(induction));
                            var result = await Get.toNamed(Routes.formPage,
                                arguments: [
                                  'induction',
                                  induction.toJson(),
                                  true
                                ]);
                            if (result == true) {
                              controller.getPermitData();
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        onTap: () {
                          // Handle on tap if needed
                          onTapView(context, induction);
                        },
                      ),
                    );
                  },
                ),
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
                  onPressed: ((controller.currentPage.value + 1) *
                              controller.itemsPerPage <
                          controller.filteredInductions.length)
                      ? () => controller.nextPage()
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Get.toNamed(
            Routes.formPage,
            arguments: ['induction', <String, dynamic>{}, false],
          );
          if (result == true) {
            controller.getPermitData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<dynamic> onTapView(BuildContext context, Induction inductionData) {
  print("fffffffffffffffffffffff${jsonEncode(inductionData)}");
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
      String imageUrl = inductionData.documentaryEvidencePhoto ?? "";
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
                      'Induction Details',
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
                _buildDetailRow('Topic:', inductionData.typeOfTopic.topicTypes),
                _buildDetailRow(
                    'Date:',
                    DateFormat("dd MMM yyyy")
                        .format(DateTime.parse(inductionData.date))),
                _buildDetailRow('Time:', inductionData.time),
                _buildDetailRow(
                    'Project Name:', inductionData.project.projectName ?? ""),
                _buildDetailRow(
                    'Form Filled:',
                    inductionData.tradeTypes
                        .map((e) => e.tradeTypes)
                        .join(",")),
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
                _buildDetailRow('Inductees:', inductionData.inductees),
                _buildDetailRow('Inductees Name:', inductionData.inducteesName),
                _buildDetailRow(
                    'Sub Contractor Name:', inductionData.subContractorName),
                _buildDetailRow(
                    'Instruction By:', inductionData.instructionBy.name ?? ""),
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
