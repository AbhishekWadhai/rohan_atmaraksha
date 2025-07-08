import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/services/shared_preferences.dart';

class SavedFormDataController extends GetxController {
  String formKey = "savedFormDataKey";
  RxList<Map<String, dynamic>> savedFormData = <Map<String, dynamic>>[].obs;

  fetchSavedFormData() async {
    String? fetchedFormData = await SharedPrefService().getString(formKey);
  }
}
