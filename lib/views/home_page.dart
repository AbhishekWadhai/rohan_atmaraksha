import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/app_constants/asset_path.dart';
import 'package:rohan_atmaraksha/app_constants/colors.dart';
import 'package:rohan_atmaraksha/app_constants/textstyles.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/widgets/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const MyDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 200,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  })),
              Column(
                mainAxisAlignment: MainAxisAlignment.end, //,
                children: [
                  Text(Strings.rohanEkam, style: TextStyles.appBarTextStyle),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF0E2D98)),
                      height: 60,
                      width: double.infinity,
                      child: FittedBox(
                        child: Row(children: [
                          CountnName(count: 02, name: Strings.workPermit),
                          const VerticalDivider(color: Colors.white),
                          CountnName(count: 02, name: Strings.workPermit),
                          const VerticalDivider(),
                          CountnName(count: 02, name: Strings.workPermit),
                          const VerticalDivider(),
                          CountnName(count: 02, name: Strings.workPermit),
                        ]),
                      ),
                    ),
                  )
                  //
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Responsibilities",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3),
                  children: [
                    MyGrid(
                        image: Image.asset(Assets.workPermit),
                        activity: Strings.workPermit,
                        onTap: () {
                          Get.toNamed(Routes.workPermitPage);
                        }),
                    MyGrid(
                        image: Image.asset(Assets.tbtMeeting),
                        activity: Strings.tbtMeeting,
                        onTap: () {
                          Get.toNamed(Routes.tbtMeetingPage);
                        }),
                    MyGrid(
                        image: Image.asset(Assets.safetyCheck),
                        activity: Strings.safetyCheck,
                        onTap: () {
                          Get.toNamed(Routes.safetyCheckPage);
                        }),
                    MyGrid(
                        image: Image.asset(Assets.sora),
                        activity: Strings.sora,
                        onTap: () {
                          Get.toNamed(Routes.soraPage);
                        }),
                    MyGrid(
                        image: Image.asset(Assets.incidentReport),
                        activity: Strings.incidentReport,
                        onTap: () {
                          Get.toNamed(Routes.incidentReportPage);
                        }),
                    MyGrid(
                        image: Image.asset(Assets.training),
                        activity: Strings.safetyInduction,
                        onTap: () {
                          Get.toNamed(Routes.safetyTraining);
                        }),
                  ],
                ),
              ),
              const Text(
                "Quick Action",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3),
                  children: [
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.workPermit,
                        onTap: () {
                          Get.toNamed(
                            Routes.formPage,
                            arguments: [
                              'workpermit',
                              <String, dynamic>{},
                              false
                            ],
                          );
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.tbtMeeting,
                        onTap: () {
                          Get.toNamed(Routes.tbtMeetingPage);
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.safetyCheck,
                        onTap: () {
                          Get.toNamed(Routes.safetyCheckPage);
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.sora,
                        onTap: () {
                          Get.toNamed(Routes.soraPage);
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.incidentReport,
                        onTap: () {
                          Get.toNamed(Routes.incidentReportPage);
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.safetyInduction,
                        onTap: () {
                          Get.toNamed(Routes.safetyInductionPage);
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.incidentReport,
                        onTap: () {
                          Get.toNamed(Routes.incidentReportPage);
                        }),
                    MyGridQuick(
                        image: Image.asset("assets/create_work_permit.png"),
                        activity: Strings.safetyInduction,
                        onTap: () {
                          Get.toNamed(Routes.safetyInductionPage);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountnName extends StatelessWidget {
  final int count;
  final String name;
  const CountnName({
    super.key,
    required this.count,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          FittedBox(
              child: Text(
            '02',
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue.shade200),
          )),
          const FittedBox(
              child: Text(
            "Work Permit",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ))
        ],
      ),
    );
  }
}

class MyGrid extends StatelessWidget {
  final Image image;
  final String activity;
  final VoidCallback onTap;
  const MyGrid(
      {super.key,
      required this.image,
      required this.activity,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 6,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(child: image),
                    Text(
                      activity,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class MyGridQuick extends StatelessWidget {
  final Image image;
  final String activity;
  final VoidCallback onTap;
  const MyGridQuick(
      {super.key,
      required this.image,
      required this.activity,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                image,
                Text(
                  activity,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ));
  }
}
