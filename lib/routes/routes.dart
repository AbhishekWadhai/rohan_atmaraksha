import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/views/home_page.dart';
import 'package:rohan_suraksha_sathi/views/safety_report.dart';
import 'package:rohan_suraksha_sathi/views/induction_page.dart';
import 'package:rohan_suraksha_sathi/views/login_page.dart';
import 'package:rohan_suraksha_sathi/views/notification_page.dart';
import 'package:rohan_suraksha_sathi/views/safety_check.dart';
import 'package:rohan_suraksha_sathi/views/safety_training.dart';
import 'package:rohan_suraksha_sathi/views/sora.dart';
import 'package:rohan_suraksha_sathi/views/specific_training_page.dart';
import 'package:rohan_suraksha_sathi/views/tbt_meeting.dart';
import 'package:rohan_suraksha_sathi/views/work_permit.dart';
import 'package:rohan_suraksha_sathi/views/form_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.loginPage, page: () => LoginPage()),
    GetPage(name: Routes.homePage, page: () => HomePage()),
    GetPage(name: Routes.workPermitPage, page: () => WorkPermitPage()),
    GetPage(name: Routes.tbtMeetingPage, page: () => TBTMeetingPage()),
    GetPage(name: Routes.safetyCheckPage, page: () => const SafetyCheckPage()),
    GetPage(name: Routes.soraPage, page: () => UaucPage()),
    GetPage(name: Routes.safetyReportPage, page: () => IncidentPage()),
    GetPage(name: Routes.safetyTraining, page: () => const SafetyTraining()),
    GetPage(name: Routes.inductionPage, page: () => InductionPage()),
    GetPage(
        name: Routes.speceficTrainingPage, page: () => SpecificTrainingPage()),
    GetPage(name: Routes.formPage, page: () => FormPage()),
    GetPage(name: Routes.notificationPage, page: () => NotificationPage()),
  ];
}
