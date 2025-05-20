import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/app_constants/asset_path.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'dart:async';

import 'package:rohan_suraksha_sathi/helpers/custom_card.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';

void main() {
  runApp(MaterialApp(
    home: AutoCarousel(),
  ));
}

class AutoCarousel extends StatefulWidget {
  @override
  _AutoCarouselState createState() => _AutoCarouselState();
}

class _AutoCarouselState extends State<AutoCarousel> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  // List of images or widgets for the carousel
  final List<Widget> _carouselItems = [
    CardFb2(
      totalNo: Strings.workpermit.length.toString(),
      text: 'Work Permit',
      imageUrl: Assets.workPermit,
      subtitle: 'Available Work Permit',
      onPressed: () {
        Get.toNamed(Routes.workPermitPage);
      },
    ),
    CardFb2(
      totalNo: Strings.induction.length.toString(),
      text: 'Inductees',
      imageUrl: Assets.workPermit,
      subtitle: 'Total number of inductees',
      onPressed: () {Get.toNamed(Routes.inductionPage);},
    ),
    CardFb2(
      totalNo: Strings.uauc.length.toString(),
      text: 'UA UC',
      imageUrl: Assets.workPermit,
      subtitle: 'Reported incidents ',
      onPressed: () {Get.toNamed(Routes.soraPage);},
    ),
    CardFb2(
      totalNo: Strings.specific.length.toString(),
      text: 'Specific Training',
      imageUrl: Assets.workPermit,
      subtitle: 'Specific Training Conducted',
      onPressed: () {Get.toNamed(Routes.speceficTrainingPage);},
    ),
    CardFb2(
      totalNo: Strings.meetings.length.toString(),
      text: 'TBT Meetings',
      imageUrl: Assets.workPermit,
      subtitle: 'TBT Meetings Conducted',
      onPressed: () {Get.toNamed(Routes.tbtMeetingPage);},
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Start the auto-scrolling timer
    _timer = Timer.periodic(Duration(seconds: 1000), _onTimerTick);
  }

  // Function to move to the next page every 3 seconds
  void _onTimerTick(Timer timer) {
    if (_currentPage < _carouselItems.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0; // Reset to the first page
    }

    // Move to the next page
    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100, // Set the desired height for the carousel
          child: Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: null, // Infinite looping
              itemBuilder: (context, index) {
                // Loop the carousel items infinitely
                int currentIndex = index % _carouselItems.length;
                return _carouselItems[currentIndex];
              },
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page % _carouselItems.length;
                });
              },
            ),
          ),
        ),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_carouselItems.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.appMainDark : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
