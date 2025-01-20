import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/env.dart';
import 'package:rohan_suraksha_sathi/main.dart';
import 'package:rohan_suraksha_sathi/services/firebase_service.dart';
import 'package:rohan_suraksha_sathi/services/jwt_service.dart';
import 'package:rohan_suraksha_sathi/services/notification_service/notification_handler.dart';
import 'package:rohan_suraksha_sathi/services/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Widgets binding initialized');
  Get.put(NotificationHandler());
  // Setup environment
  try {
    AppEnvironment.setupEnv(Environment.dev);
    print('Environment setup done');

    // Initialize Firebase
    await Firebase.initializeApp();
    print('Firebase initialized');

    // Initialize Firebase notifications
    await FirebaseApi().initNotifications();
    print('Notifications initialized');

    // Background handler for FCM
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print('Background message handler set');

    // Check if the user is logged in
    bool isLoggedIn = await isTokenValid();
    print('Token valid: $isLoggedIn');

    // Run the app
    runApp(MyApp(isLoggedIn: isLoggedIn));
  } catch (e) {
    print('Error initializing Firebase: $e');

    // Handle Firebase initialization error
    try {
      await requestEssentialPermissions();
      bool isLoggedIn = await isTokenValid();
      runApp(MyApp(isLoggedIn: isLoggedIn));
    } catch (innerError) {
      print('Error in fallback logic: $innerError');
      runApp(const MyApp(isLoggedIn: false));
    }
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized before handling the background message
  await Firebase.initializeApp();
  try {
    // Access the NotificationController
    NotificationHandler notificationController =
        Get.find<NotificationHandler>();
    notificationController.getNotifications(); // Call the method
    print('getNotifications called successfully');
  } catch (e) {
    print('Error calling getNotifications: $e');
  }
  print('Handling a background message: ${message.messageId}');
}
