import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/bindings/save_form_data_bindings.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/views/action_view.dart';
import 'package:rohan_suraksha_sathi/views/app_infor.dart';
import 'package:rohan_suraksha_sathi/views/home_page/home_page.dart';
import 'package:rohan_suraksha_sathi/views/safety_report.dart';
import 'package:rohan_suraksha_sathi/views/induction_page.dart';
import 'package:rohan_suraksha_sathi/views/login_page.dart';
import 'package:rohan_suraksha_sathi/views/notification_page.dart';
import 'package:rohan_suraksha_sathi/views/safety_check.dart';
import 'package:rohan_suraksha_sathi/views/safety_training.dart';
import 'package:rohan_suraksha_sathi/views/saved_form_data/saved_form_data.dart';
import 'package:rohan_suraksha_sathi/views/uauc_view.dart';
import 'package:rohan_suraksha_sathi/views/specific_training_page.dart';
import 'package:rohan_suraksha_sathi/views/tbt_meeting.dart';
import 'package:rohan_suraksha_sathi/views/user_details.dart';
import 'package:rohan_suraksha_sathi/views/user_details_list_view.dart';
import 'package:rohan_suraksha_sathi/views/work_permit.dart';
import 'package:rohan_suraksha_sathi/views/form_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.loginPage, page: () => LoginPage()),
    GetPage(name: Routes.homePage, page: () => HomePage()),
    GetPage(name: Routes.userDetailsDataPage, page: () => USerDetailsData()),
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
    GetPage(
        name: Routes.userDetailsListView, page: () => UserDetailsListView()),
    GetPage(
      name: Routes.actionView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return ActionView(title: args['title']);
      },
    ),
    GetPage(
        name: Routes.savedFormData,
        page: () => SavedFormData(),
        binding: SavedFormDataBindings()),
    GetPage(name: Routes.packageInfoPage, page: () => PackageInfoPage()),
  ];
}
