import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';

class ActionViewController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  getData(String source) async {
    try {
      final activityData = await ApiService().getRequest(source);

      if (activityData == null) {
        throw Exception("Received null data from API");
      }
    } catch (e) {}
  }
}
