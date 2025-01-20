import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/asset_path.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/app_constants/textstyles.dart';
import 'package:rohan_suraksha_sathi/controller/home_controller.dart';
import 'package:rohan_suraksha_sathi/helpers/chart_illustration.dart';
import 'package:rohan_suraksha_sathi/helpers/sixed_boxes.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/widgets/auto_move_slider.dart';
import 'package:rohan_suraksha_sathi/widgets/helper_widgets/flexibleText.dart';
import 'package:rohan_suraksha_sathi/widgets/my_drawer.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      endDrawer: const MyDrawer(),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 1, // Spread of the shadow
                    blurRadius: 10, // How blurry the shadow is
                    offset: const Offset(
                        0, 4), // Shadow's position (horizontal, vertical)
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30), // Set bottom-left radius
                  bottomRight: Radius.circular(30), // Set bottom-right radius
                ),
              ),
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30), // Set bottom-left radius
                      bottomRight:
                          Radius.circular(30), // Set bottom-right radius
                    ),
                    // Add your blue tint to the background image
                    image: DecorationImage(
                      opacity: 0.1,
                      image: const AssetImage(
                          Assets.appBarBg), // Replace with your image path
                      fit: BoxFit.cover, // Ensure the image covers the AppBar
                      colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.1), // Blue tint with opacity
                        BlendMode.overlay, // Overlay mode to apply the tint
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                "Welcome, ${Strings.userName},",
                                style: TextStyles.appBarTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const SizedBox(width: 3),
                                Text(Strings.locationName,
                                    style: TextStyles.appBarSubTextStyle),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 3),
                                Text(
                                    DateFormat('d, MMM').format(DateTime.now()),
                                    style: TextStyles.appBarSubTextStyle),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.notificationPage);
                              },
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.black,
                                size: 30, // Set size for consistency
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Builder(builder: (context) {
                                return GestureDetector(
                                  child: SizedBox(
                                    width: 30, // Set width for consistency
                                    height: 30, // Set height for consistency
                                    child: Image.asset(
                                      Assets.rohanLogo,
                                      fit: BoxFit
                                          .contain, // Ensures the image fits the container
                                    ),
                                  ),
                                  onTap: () {
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    AutoCarousel(),
                    sb20,
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(
                          8.0), // Adds spacing inside the container
                      child: Column(
                        children: [
                          const Text("Responsibilities"),
                          GridView(
                            shrinkWrap:
                                true, // Allows GridView to size dynamically
                            physics:
                                const NeverScrollableScrollPhysics(), // Prevents scrolling inside the grid
                            padding:
                                EdgeInsets.zero, // Removes any default padding
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two items per row
                              mainAxisSpacing: 0, // No extra vertical spacing
                              crossAxisSpacing:
                                  2.0, // Spacing between items horizontally
                              childAspectRatio:
                                  4 / 2, // Adjusts the child width/height ratio
                            ),
                            children: [
                              if (Strings.roleName == "Execution" ||
                                  Strings.roleName == "Admin")
                                MyGrid(
                                  avatarColor: Colors.red[100]!,
                                  image: Image.asset(Assets.workPermit),
                                  activity: Strings.workPermit,
                                  onTap: () {
                                    Get.toNamed(Routes.workPermitPage);
                                  },
                                ),
                              if (Strings.roleName == "Safety" ||
                                  Strings.roleName == "Admin")
                                MyGrid(
                                  avatarColor: Colors.blue[100]!,
                                  image: Image.asset(Assets.training),
                                  activity: Strings.safetyTraining,
                                  onTap: () {
                                    Get.toNamed(Routes.safetyTraining);
                                  },
                                ),
                              MyGrid(
                                avatarColor: Colors.green[100]!,
                                image: Image.asset(Assets.sora),
                                activity: Strings.uauc,
                                onTap: () {
                                  Get.toNamed(Routes.soraPage);
                                },
                              ),
                              MyGrid(
                                avatarColor: Colors.orange[100]!,
                                image: Image.asset(Assets.incidentReport),
                                activity: Strings.safetyReport,
                                onTap: () {
                                  Get.toNamed(Routes.safetyReportPage);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    sb18,
                    Container(
                        height: 200,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: IllustrationFb4(),
                        ))
                  ],
                ),
              ),
            ),
          ),

          // const ExpansionTile(title: Text("Expansion Tile"))
        ],
      ),
    );
  }
}

class MyGrid extends StatelessWidget {
  final Image image;
  final String activity;
  final VoidCallback onTap;
  final Color avatarColor;

  MyGrid({
    super.key,
    required this.image,
    required this.activity,
    required this.onTap,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: Colors.white, // Explicit background color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Reduced opacity
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            border: Border.all(width: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: avatarColor,
                  child: image,
                ),
                const Spacer(),
                FlexibleText(
                  baseFontSize: 12,
                  text: activity,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
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
