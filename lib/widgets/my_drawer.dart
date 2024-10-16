import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/app_constants/asset_path.dart';
import 'package:rohan_atmaraksha/app_constants/textstyles.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/services/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Image.asset(Assets.workPermit),
                  ),
                  onTap: () {
                    Get.toNamed(Routes.workPermitPage);
                  },
                  title: Text(
                    Strings.workPermit,
                    style: TextStyles.drawerTextStyle,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Image.asset(Assets.workPermit),
                  ),
                  onTap: () {
                    Get.toNamed(Routes.tbtMeetingPage);
                  },
                  title: Text(
                    Strings.tbtMeeting,
                    style: TextStyles.drawerTextStyle,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Image.asset(Assets.workPermit),
                  ),
                  onTap: () {
                    Get.toNamed(Routes.safetyCheckPage);
                  },
                  title: Text(
                    Strings.safetyInduction,
                    style: TextStyles.drawerTextStyle,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Image.asset(Assets.sora)),
                  onTap: () {
                    Get.toNamed(Routes.soraPage);
                  },
                  title: Text(
                    Strings.uauc,
                    style: TextStyles.drawerTextStyle,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Image.asset(Assets.workPermit),
                  ),
                  onTap: () {
                    Get.toNamed(Routes.incidentReportPage);
                  },
                  title: Text(
                    Strings.incidentReport,
                    style: TextStyles.drawerTextStyle,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Image.asset(Assets.workPermit),
                  ),
                  onTap: () {
                    Get.toNamed(
                        Routes.safetyInductionPage); // Corrected route name
                  },
                  title: Text(
                    Strings.safetyTraining,
                    style: TextStyles.drawerTextStyle,
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            onTap: () async {
              SharedPrefService().remove("token");
              SharedPrefService().remove("decodedData");
              Get.offAllNamed(
                  Routes.loginPage); // Replace with your login route
            },
            title: Text(
              'Logout',
              style: TextStyles.drawerTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
