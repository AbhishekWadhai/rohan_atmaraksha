import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/asset_path.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/app_constants/textstyles.dart';
import 'package:rohan_suraksha_sathi/controller/home_controller.dart';
import 'package:rohan_suraksha_sathi/helpers/sixed_boxes.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/formatters.dart';
import 'package:rohan_suraksha_sathi/views/home_page/home_page.dart';
import 'package:rohan_suraksha_sathi/widgets/auto_move_slider.dart';
import 'package:rohan_suraksha_sathi/widgets/dashboard.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeView extends StatelessWidget {
  HomeView({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.appMainDark,
              AppColors.appMainMid,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Builder(builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Builder(
                        builder: (drawerContext) => GestureDetector(
                          onTap: () {
                            print("Calling Drawer");
                            Scaffold.of(drawerContext).openEndDrawer();
                          },
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Image.asset(
                                  Assets.rohanLogo,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                expandedHeight: 240,
                toolbarHeight: 120,
                pinned: true,
                flexibleSpace: AppBarContent(
                  controller: controller,
                  context: context,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  // transform: Matrix4.translationValues(
                  //     0.0, -50.0, 0.0), // Optional overlap
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Highlights",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Obx(
                              () => TextButton.icon(
                                iconAlignment: IconAlignment.end,
                                onPressed: () async {
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
                                            controller.selectedRange.value =
                                                DateTimeRange(
                                              start: value.startDate ??
                                                  DateTime.now(),
                                              end: value.endDate ??
                                                  value.startDate ??
                                                  DateTime.now(),
                                            );

                                            Get.back();
                                          }
                                        },
                                        onCancel: () => Get.back(),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.more_vert_rounded, size: 16),
                                label: Text(
                                  isSameDay(
                                          controller.selectedRange.value.start,
                                          controller.selectedRange.value.end)
                                      ? "Today"
                                      : controller.selectedRange.value.start ==
                                              controller.selectedRange.value.end
                                          ? DateFormat('dd MMM').format(
                                              controller
                                                  .selectedRange.value.start)
                                          : "${DateFormat('dd MMM').format(controller.selectedRange.value.start)} - ${DateFormat('dd MMM').format(controller.selectedRange.value.end)}",
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => AutoCarousel(
                            selectedRange: controller.selectedRange.value),
                      ),
                      sb6,
                      const Divider(color: Colors.black87),
                      sb6,
                      Text(
                        "Quick Actions",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      sb12,
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: QuickActionRow(),
                        ),
                      ),
                      sb6,
                      const Divider(color: Colors.black87),
                      sb6,
                      Container(
                        height: 250,
                        decoration: const BoxDecoration(
                          color: AppColors.appMainMid,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: DashboardPage(
                          homeController: controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Row QuickActionRow() {
    return Row(
      children: [
        MyGridQuick(
            image: Image.asset(Assets.workPermit),
            activity: "Create Permit",
            onTap: () async {
              if (Strings.permisssions.contains("Workpermit Creation")) {
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: ['workpermit', <String, dynamic>{}, false],
                );
                if (result == true) {
                  Get.snackbar("Work Permit Created Successfully", "");
                }
              } else {
                Get.snackbar("Not Authorized to create Workpermit", "");
              }
            }),
        MyGridQuick(
            image: Image.asset(Assets.tbtMeeting),
            activity: "TBT Meeting",
            onTap: () async {
              if (Strings.permisssions.contains("Safety Creation")) {
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: ['meeting', <String, dynamic>{}, false],
                );
                if (result == true) {
                  Get.snackbar("TBT Meeting Created Successfully", "");
                }
              } else {
                Get.snackbar("Not Authorized to create TBT Meeting", "");
              }
            }),
        MyGridQuick(
            image: Image.asset(Assets.safetyInduction),
            activity: "Safety Induction",
            onTap: () async {
              if (Strings.permisssions.contains("Safety Creation")) {
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: ['induction', <String, dynamic>{}, false],
                );
                if (result == true) {
                  Get.snackbar("Safety Induction Created Successfully", "");
                }
              } else {
                Get.snackbar("Not Authorized to create Safety Induction", "");
              }
            }),
        MyGridQuick(
            image: Image.asset(Assets.specificTraining),
            activity: "Specific Training",
            onTap: () async {
              if (Strings.permisssions.contains("Safety Creation")) {
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: ['specific', <String, dynamic>{}, false],
                );
                if (result == true) {
                  Get.snackbar("Specific Traiing Created Successfully", "");
                }
              } else {
                Get.snackbar("Not Authorized to create Specific Training", "");
              }
            }),
        MyGridQuick(
            image: Image.asset(Assets.uauc),
            activity: "Reporting UAUC",
            onTap: () async {
              if (Strings.permisssions.contains("UAUC Creation")) {
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: ['uauc', <String, dynamic>{}, false],
                );
                if (result == true) {
                  Get.snackbar("UAUC Reported Successfully", "");
                }
              } else {
                Get.snackbar("Not Authorized to create UAUC", "");
              }
            }),
        MyGridQuick(
            image: Image.asset(Assets.safetyReport),
            activity: "Safety Reporting",
            onTap: () async {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: ['safetyreport', <String, dynamic>{}, false],
              );
              if (result == true) {
                Get.snackbar("Safety Data Reported Successfully", "");
              }
            }),
      ],
    );
  }
}

class AppBarContent extends StatelessWidget {
  AppBarContent({
    super.key,
    required this.controller,
    required this.context,
  });

  final HomeController controller;
  BuildContext context;

  @override
  Widget build(context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.appMainDark,
                      AppColors.appMainMid,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0), // Set bottom-left radius
                    bottomRight: Radius.circular(0), // Set bottom-right radius
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // Prevents overflow by taking only available space
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    _showProjectSelector();
                                  },
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          Strings.endpointToList['project']
                                                  ?['projectName'] ??
                                              "",
                                          style: TextStyles.appBarTextStyle,
                                          overflow: TextOverflow
                                              .ellipsis, // Prevents overflow
                                        ),
                                      ),
                                      sb1,
                                      Flexible(
                                        child: Text(
                                          Strings.endpointToList['project']
                                                  ?['siteLocation'] ??
                                              "",
                                          style: TextStyles.appBarTextStyle,
                                          overflow: TextOverflow
                                              .ellipsis, // Prevents overflow
                                        ),
                                      ),
                                      sb2,
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      " ${Strings.userName},",
                                      style: TextStyles.appBarSubTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(width: 3),
                                    Text(
                                      DateFormat('d, MMM')
                                          .format(DateTime.now()),
                                      style: TextStyles.appBarSubTextStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(
                          8.0), // Adds spacing inside the container
                      child: Column(
                        children: [
                          GridView(
                            shrinkWrap:
                                true, // Allows GridView to size dynamically
                            physics:
                                const NeverScrollableScrollPhysics(), // Prevents scrolling inside the grid
                            padding:
                                EdgeInsets.zero, // Removes any default padding
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // Two items per row
                              mainAxisSpacing: 0, // No extra vertical spacing
                              crossAxisSpacing:
                                  0.0, // Spacing between items horizontally
                              childAspectRatio:
                                  1, // Adjusts the child width/height ratio
                            ),
                            children: [
                              if (Strings.roleName == "Execution" ||
                                  Strings.roleName == "Management" ||
                                  Strings.roleName == "Project Manager" ||
                                  Strings.roleName == "Admin" &&
                                      Strings.endpointToList['project']
                                              ?["workpermitAllow"] ==
                                          "yes")
                                MyGrid(
                                  avatarColor: Colors.red[100]!,
                                  image: Image.asset(Assets.workPermit),
                                  activity: Strings.permit,
                                  onTap: () {
                                    Get.toNamed(Routes.workPermitPage);
                                  },
                                ),
                              if (Strings.roleName == "Safety" ||
                                  Strings.roleName == "Management" ||
                                  Strings.roleName == "Project Manager" ||
                                  Strings.roleName == "Admin")
                                MyGrid(
                                  avatarColor: Colors.blue[100]!,
                                  image: Image.asset(Assets.training),
                                  activity: Strings.training,
                                  onTap: () {
                                    Get.toNamed(Routes.safetyTraining);
                                  },
                                ),
                              Obx(() => MyGrid(
                                    avatarColor: Colors.green[100]!,
                                    image: Image.asset(Assets.uauc),
                                    activity: Strings.uaucs,
                                    onTap: () {
                                      Get.toNamed(Routes.soraPage);
                                    },
                                    showBadge:
                                        controller.hasPendingActions.value,
                                  )),
                              MyGrid(
                                avatarColor: Colors.orange[100]!,
                                image: Image.asset(Assets.safetyReport),
                                activity: Strings.reporting,
                                onTap: () {
                                  Get.toNamed(Routes.safetyReportPage);
                                },
                              ),
                              // MyGrid(
                              //   avatarColor: Colors.orange[100]!,
                              //   image: Image.asset(Assets.safetyReport),
                              //   activity: "Checklist",
                              //   onTap: () {
                              //     Get.toNamed(Routes.actionView);
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    });
  }

  void _showProjectSelector() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Strings.endpointToList["mappedProjects"].length,
          itemBuilder: (_, index) {
            final project = Strings.endpointToList["mappedProjects"][index];
            return ListTile(
              leading: const Icon(
                Icons.location_on_rounded,
                color: Colors.red,
              ),
              title: Text(project['projectName'] ?? ''),
              subtitle: Text(project['siteLocation'] ?? ''),
              onTap: () {
                controller.changeProject(project);
                // Strings.endpointToList["project"] = project;
                // Get.offAllNamed(Routes.homePage);
                // print(Strings.endpointToList["project"]);
                // //Get.back();
              },
            );
          },
        ),
      ),
    );
  }
}
