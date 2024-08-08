import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/app_constants/textstyles.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
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
            onTap: () {
              Get.toNamed(Routes.safetyCheckPage);
            },
            title: Text(
              Strings.safetyCheck,
              style: TextStyles.drawerTextStyle,
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Get.toNamed(Routes.soraPage);
            },
            title: Text(
              Strings.sora,
              style: TextStyles.drawerTextStyle,
            ),
          ),
          const Divider(),
          ListTile(
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
            onTap: () {
              Get.toNamed(Routes.incidentReportPage);
            },
            title: Text(
              Strings.safetyInduction,
              style: TextStyles.drawerTextStyle,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
