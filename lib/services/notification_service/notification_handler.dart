
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';

class NotificationHandler {
  getNotifications() async {
    Strings.notifications =
        await ApiService().getRequest("notifications/${Strings.userId}");
  }

  Future<void> sendNotification({
  required List<Map<String, String>> notifications,
}) async {
  try {
    final response = await ApiService().postRequest("notifications", notifications);

    if (response == 201) {
      print('Notifications sent successfully');
    } else {
      print('Failed to send notifications: ${response.body}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

}
