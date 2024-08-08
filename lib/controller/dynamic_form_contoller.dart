import 'package:get/get.dart';

import 'package:rohan_atmaraksha/model/form_data_model.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';

class DynamicFormController extends GetxController {
  var formResponse = <ResponseForm>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getFromJson();
  }

  Future<void> getFromJson() async {
    // Load JSON file from assets
    final jsonResult = await ApiService().getRequest("fields");

    // Parse JSON data into model classes
    formResponse.value = jsonResult
        .map<ResponseForm>((element) => ResponseForm.fromJson(element))
        .toList();

    isLoading.value = false;
  }
}
