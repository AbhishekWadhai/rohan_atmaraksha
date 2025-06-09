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
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  final RxList<Map<String, dynamic>> topics =
      (Strings.endpointToList["topic"] as List?)
              ?.cast<Map<String, dynamic>>()
              .obs ??
          <Map<String, dynamic>>[].obs;
  var selectedTopics = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTBTMeetings();
  }

  List<TbtMeeting> get paginatedTBTMeetings {
    final List<TbtMeeting> filteredList =
        (tbtMeetingList as List<TbtMeeting>).where((TbtMeeting meeting) {
      // Check if typeOfTopic contains the search query
      bool typeMatches = meeting.typeOfTopic!.any((TypeOfTopic topic) => topic
          .topicTypes
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()));

      // Check if date contains search query
      bool dateMatches = meeting.date != null &&
          meeting.date!.toLowerCase().contains(searchQuery.value.toLowerCase());

      // Parse the meeting date to DateTime
      final meetingDate = DateTime.tryParse(meeting.date ?? "");

      // Check if within date range
      final isWithinDateRange = (startDate.value == null ||
              (meetingDate != null &&
                  !meetingDate.isBefore(startDate.value!))) &&
          (endDate.value == null ||
              (meetingDate != null &&
                  !meetingDate.isAfter(
                      endDate.value!.add(Duration(days: 1))))); // ✅ Inclusive

      final matchesTopic = selectedTopics.isEmpty ||
          (meeting.typeOfTopic != null &&
              meeting.typeOfTopic!
                  .any((topic) => selectedTopics.contains(topic.id)));

      return (typeMatches || dateMatches) && isWithinDateRange && matchesTopic;
    }).toList();

    // Pagination logic (if you use it)
    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;
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
