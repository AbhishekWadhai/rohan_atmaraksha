import 'dart:convert';

import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/tbt_meeting.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';

class TBTMeetingController extends GetxController {
  RxList<TbtMeeting> tbtMeetingList = <TbtMeeting>[].obs;
  RxInt currentPage = 0.obs;
  final int itemsPerPage = 20;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTBTMeetings();
  }

  List<TbtMeeting> get paginatedTBTMeetings {
    // Explicitly cast tbtMeetingList to List<TbtMeeting> to ensure proper typing
    final List<TbtMeeting> filteredList =
        (tbtMeetingList as List<TbtMeeting>).where((TbtMeeting meeting) {
      // Check if `typeOfTopic` contains the search query in any `topicTypes`
      bool typeMatches = meeting.typeOfTopic!.any((TypeOfTopic topic) => topic
          .topicTypes
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()));

      // Check if the search query matches the `date`
      bool dateMatches =
          meeting.date!.toLowerCase().contains(searchQuery.value.toLowerCase());

      // Return true if either condition matches
      return typeMatches || dateMatches;
    }).toList();

    // Calculate the start and end indices for pagination
    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;

    // Return the paginated sublist
    return filteredList.sublist(
        start, end > filteredList.length ? filteredList.length : end);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // Reset to the first page after a new search
  }

  void nextPage() {
    if ((currentPage.value + 1) * itemsPerPage < tbtMeetingList.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  fetchTBTMeetings() async {
    try {
      final meetingData = await ApiService().getRequest("meeting");

      if (meetingData == null) {
        throw Exception("Received null data from API");
      }

      if (meetingData is List) {
        if (Strings.roleName == "Admin") {
          tbtMeetingList.value = meetingData
              .where((e) => e != null)
              .map((e) => TbtMeeting.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          tbtMeetingList.value = meetingData
              .where((e) => e != null)
              .map((e) => TbtMeeting.fromJson(e as Map<String, dynamic>))
              .where((data) =>
                  data.project?.id == Strings.endpointToList['project']['_id'])
              .toList();
        }
      } else {
        throw Exception("Unexpected data format");
      }

      print("TBT Meeting List Length: ${tbtMeetingList.length}");
    } catch (e) {
      print("Error fetching TBT meeting data: $e");
    }
  }

  deleteSelection(String key) async {
    await ApiService().deleteRequest("meeting", key);
    fetchTBTMeetings();
  }
}
