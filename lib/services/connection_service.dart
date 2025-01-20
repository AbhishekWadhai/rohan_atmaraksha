import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class ConnectivityService {
  static bool hasRestarted = false; // Flag to prevent multiple restarts
  static Stream<List<ConnectivityResult>>?
      _connectivityStream; // Store the stream reference

  // Method to show persistent toast message based on connectivity status
  static void checkAndShowOfflineSnackbar() async {
    // If already subscribed to the stream, return
    if (_connectivityStream != null) return;

    _connectivityStream = Connectivity().onConnectivityChanged;

    // Check current connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();
    // _handleConnectivityChange(connectivityResult);

    // Listen for connectivity changes
    // _connectivityStream?.listen((ConnectivityResult result) {
    //   _handleConnectivityChange(result);
    // });
  }

  // Private method to handle connectivity changes
  static void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _showOfflineToast();
    } else {
      _dismissOfflineToast();

      // Restart the app only if it hasn't been restarted yet
      // if (!hasRestarted) {
      //   hasRestarted = true; // Mark as restarted
      //   _restartApp();
      // }
    }
  }

  // Private method to show the toast
  static void _showOfflineToast() {
    Get.showSnackbar(
      const GetSnackBar(
        message: "You are offline. Please turn on data/Wi-Fi to continue.",
        duration: Duration(days: 365), // Snackbar will persist
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: false, // Prevents dismissal unless explicitly dismissed
      ),
    );
  }

  // Private method to dismiss the toast
  static void _dismissOfflineToast() {
    Get.closeAllSnackbars(); // Dismiss all active toasts/snackbars
  }

  // Method to restart the app once the user goes online
  static void _restartApp() {
    Restart.restartApp(
      // Customizing the restart notification message (only needed on iOS)
      notificationTitle: 'Restarting App',
      notificationBody: 'Please tap here to open the app again.',
    );
  }
}
