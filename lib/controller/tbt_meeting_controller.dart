import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/model/tbt_meeting.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';

class TbtMeetingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxList<TbtMeeting> meetingList = <TbtMeeting>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getPermitData();
  }

  getPermitData() async {
    try {
      final meetingtData = await ApiService().getRequest("meeting");

      if (meetingtData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (meetingtData is List) {
        // Check for any null elements in the list
        meetingList.value = meetingtData
            .where((e) => e != null)
            .map((e) => TbtMeeting.fromJson(e as Map<String, dynamic>))
            .toList();
        print("---------------------Permit called---------------------");
        print(jsonEncode(meetingList));
      } else {
        throw Exception("Unexpected data format");
      }

      print("---------------------Permit called---------------------");
      print("Permit List Length: ${meetingtData.length}");
    } catch (e) {
      print("Error fetching permit data: $e");
      // Handle the error accordingly, e.g., show a dialog or retry
    }
  }

  deleteSelection(String key) async {
    await ApiService().deleteRequest("meeting", key);
    getPermitData();
  }
}
