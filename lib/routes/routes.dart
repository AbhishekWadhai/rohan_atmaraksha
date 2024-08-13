import 'package:get/get.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/views/home_page.dart';
import 'package:rohan_atmaraksha/views/incident_report.dart';
import 'package:rohan_atmaraksha/views/login_page.dart';
import 'package:rohan_atmaraksha/views/safety_check.dart';
import 'package:rohan_atmaraksha/views/sora.dart';
import 'package:rohan_atmaraksha/views/tbt_meeting.dart';
import 'package:rohan_atmaraksha/views/work_permit.dart';
import 'package:rohan_atmaraksha/views/form_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.loginPage, page: () => LoginPage()),
    GetPage(name: Routes.homePage, page: () => const HomePage()),
    GetPage(name: Routes.workPermitPage, page: () => WorkPermitPage()),
    GetPage(name: Routes.tbtMeetingPage, page: () => const TBTMeetingPage()),
    GetPage(name: Routes.safetyCheckPage, page: () => const SafetyCheckPage()),
    GetPage(name: Routes.soraPage, page: () => const SoraPage()),
    GetPage(
        name: Routes.incidentReportPage,
        page: () => const IncidentReportPage()),
    GetPage(
        name: Routes.safetyInductionPage, page: () => const SafetyCheckPage()),
    GetPage(name: Routes.workPermitForm, page: () => WorkPermitFormPage()),
  ];
}
