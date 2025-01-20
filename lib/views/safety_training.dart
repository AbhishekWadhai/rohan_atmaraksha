import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rohan_suraksha_sathi/app_constants/asset_path.dart';

import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';

import '../routes/routes_string.dart';

class SafetyTraining extends StatelessWidget {
  const SafetyTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text("Safety Training"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
            children: [
              TrainingCard(
                createAction: "Create TBT Meeting",
                moduleName: "TBT Meeting",
                imageAsset: Assets.tbtMeeting,
                action1: () {
                  Get.toNamed(Routes.tbtMeetingPage);
                },
                action2: () {
                  Get.toNamed(
                    Routes.formPage,
                    arguments: ['meeting', <String, dynamic>{}, false],
                  );
                },
              ),
              TrainingCard(
                createAction: "Create Safety Induction",
                moduleName: "Safety Induction",
                imageAsset: Assets.training,
                action1: () {
                  Get.toNamed(Routes.inductionPage);
                },
                action2: () {
                  Get.toNamed(
                    Routes.formPage,
                    arguments: ['induction', <String, dynamic>{}, false],
                  );
                },
              ),
              TrainingCard(
                createAction: "Create Job Specific Safety Training",
                moduleName: "Job Specific Safety Training",
                imageAsset: Assets.training,
                action1: () {
                  Get.toNamed(Routes.speceficTrainingPage);
                },
                action2: () {
                  Get.toNamed(
                    Routes.formPage,
                    arguments: ['specific', <String, dynamic>{}, false],
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class TrainingCard extends StatelessWidget {
  final String moduleName;
  final String imageAsset;
  final VoidCallback action1;
  final VoidCallback action2;
  final String createAction;

  const TrainingCard({
    super.key,
    this.moduleName = "",
    this.imageAsset = "assets/logo.png", // Default asset path
    required this.action1,
    required this.action2,
    this.createAction = "Create New",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // GestureDetector with expanded space
            Expanded(
              child: GestureDetector(
                onTap: action1,
                child: Container(
                  width: double.infinity, // Take full width
                  color: Colors.transparent, // To ensure it's tappable
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center contents
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Image.asset(imageAsset),
                      ),
                      const SizedBox(height: 10),
                      Text(moduleName),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            // Row for the second action
            GestureDetector(
              onTap: action2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      createAction,
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                  ),
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
