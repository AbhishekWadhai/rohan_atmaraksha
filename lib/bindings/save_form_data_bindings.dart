import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/views/saved_form_data/saved_form_data_controller.dart';

class SavedFormDataBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SavedFormDataController());
  }
}
