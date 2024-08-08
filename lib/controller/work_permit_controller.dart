import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';

class WorkPermitController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // vsync from GetxController
  TabController? tabController;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    ApiService().getRequest("permitstype");

  }
}
