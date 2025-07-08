import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/asset_path.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/app_constants/textstyles.dart';
import 'package:rohan_suraksha_sathi/helpers/sixed_boxes.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), // Top-right corner radius
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double
                  .infinity, // Ensures the container spans the entire width
              decoration: BoxDecoration(
                image: DecorationImage(
                  opacity: 0.1,
                  image: const AssetImage(
                    Assets.appBarBg, // Replace with your background image path
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.appMainDark
                        .withOpacity(0.6), // Blue tint with opacity
                    BlendMode.overlay, // Overlay mode to apply the tint
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    blurRadius: 10, // How much the shadow is blurred
                    offset: const Offset(
                        0, 5), // Horizontal and vertical offset of the shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Center(
                        // Ensures the logo is centered
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(
                                0), // Remove default padding
                            child: Image.asset(
                              Assets.rohanLogo,
                              fit: BoxFit
                                  .contain, // Adjusts image fit within the SizedBox
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Rohan Suraksha Sathi",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sb10,
                    Text(
                      "${Strings.userName},",
                      style: TextStyles.appBarSubTextStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Strings.locationName,
                            style: TextStyles.appBarSubTextStyle),
                        sb12,
                        Text(DateFormat('d, MMM').format(DateTime.now()),
                            style: TextStyles.appBarSubTextStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (Strings.roleName == "Execution" ||
                      Strings.roleName == "Management" ||
                      Strings.roleName == "Project Manager" ||
                      Strings.roleName == "Admin" &&
                          Strings.endpointToList['project']
                                  ?["workpermitAllow"] ==
                              "yes") ...[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(Assets.workPermit),
                            ),
                          ),
                          sb20,
                          Text(
                            Strings.workPermit,
                            style: TextStyles.drawerTextStyle,
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.toNamed(Routes.workPermitPage);
                      },
                    ),
                    const Divider(),
                  ],
                  if (Strings.roleName == "Safety" ||
                      Strings.roleName == "Management" ||
                      Strings.roleName == "Project Manager" ||
                      Strings.roleName == "Admin") ...[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(Assets.tbtMeeting),
                            ),
                          ),
                          sb20,
                          Text(
                            Strings.tbtMeeting,
                            style: TextStyles.drawerTextStyle,
                          ),
                          sb10,
                        ],
                      ),
                      onTap: () {
                        Get.toNamed(Routes.tbtMeetingPage);
                      },
                    ),
                    const Divider(),
                  ],
                  if (Strings.roleName == "Safety" ||
                      Strings.roleName == "Management" ||
                      Strings.roleName == "Project Manager" ||
                      Strings.roleName == "Admin")...[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(Assets.safetyInduction),
                            ),
                          ),
                          sb20,
                          Text(
                            Strings.safetyInduction,
                            style: TextStyles.drawerTextStyle,
                          ),
                          sb10,
                        ],
                      ),
                      onTap: () {
                        Get.toNamed(Routes.inductionPage);
                      },
                    ),
                  const Divider(),],
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(Assets.uauc),
                          ),
                        ),
                        sb20,
                        Text(
                          Strings.uaucs,
                          style: TextStyles.drawerTextStyle,
                        ),
                        sb10,
                      ],
                    ),
                    onTap: () {
                      Get.toNamed(Routes.soraPage);
                    },
                  ),
                  const Divider(),
                  if (Strings.roleName == "Safety" ||
                      Strings.roleName == "Management" ||
                      Strings.roleName == "Project Manager" ||
                      Strings.roleName == "Admin")...[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(Assets.specificTraining),
                            ),
                          ),
                          sb20,
                          Text(
                            Strings.specificTraining,
                            style: TextStyles.drawerTextStyle,
                          ),
                          sb10,
                        ],
                      ),
                      onTap: () {
                        Get.toNamed(Routes.speceficTrainingPage);
                      },
                    ),
                  const Divider(),],
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.feedback_outlined,
                            color: Colors.black,
                          ),
                        ),
                        sb20,
                        Text(
                          "Dev. Feedback",
                          style: TextStyles.drawerTextStyle,
                        ),
                        sb10,
                      ],
                    ),
                    onTap: () {
                      Get.toNamed(
                        Routes.formPage,
                        arguments: ['feedback', <String, dynamic>{}, false],
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.vertical_split_outlined,
                            color: Colors.black,
                          ),
                        ),
                        sb20,
                        Text(
                          "App Info",
                          style: TextStyles.drawerTextStyle,
                        ),
                        sb10,
                      ],
                    ),
                    onTap: () {
                      Get.toNamed(
                        Routes.packageInfoPage,
                      );
                    },
                  ),
                  const Divider()
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              onTap: () async {
                Get.defaultDialog(
                  title: "Logout Confirmation",
                  middleText: "Are you sure you want to logout?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.black,
                  buttonColor: Colors.red,
                  onConfirm: () async {
                    // Perform logout
                    await SharedPrefService().remove("token");
                    await SharedPrefService().remove("decodedData");
                    Get.offAllNamed(
                        Routes.loginPage); // Replace with your login route
                  },
                  onCancel: () {
                    Get.back(); // Close the dialog
                  },
                );
              },
              title: Text(
                'Logout',
                style: TextStyles.drawerTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
