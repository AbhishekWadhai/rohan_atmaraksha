import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/controller/action_view_controller.dart';

class ActionView extends StatelessWidget {
  final ActionViewController controller = Get.put(ActionViewController());
  String title;
  ActionView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          //onChanged: (value) => controller.updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: "Search UAUC",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        backgroundColor: AppColors.appMainDark,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                //controller.getPermitData();
              }),
          IconButton(
            icon: const Icon(Icons.home_filled),
            onPressed: () {
              //Get.offAllNamed(Routes.homePage);
            },
          ),
        ],
        elevation: 2,
        // bottom: const TabBar(
        //   indicatorColor: Colors.white,
        //   labelColor: Colors.white,
        //   tabs: [
        //     Tab(text: "All"),
        //     Tab(text: "Open"),
        //     Tab(text: "Closed"),
        //   ],
        // ),
      ),
    );
  }
}
