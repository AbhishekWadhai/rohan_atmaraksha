// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3BV-h70h9uUA81qupCNrKkrlsnOnxazs',
    appId: '1:513749196603:web:134c09509b0efcb9d9a11e',
    messagingSenderId: '513749196603',
    projectId: 'rohan-e935d',
    authDomain: 'rohan-e935d.firebaseapp.com',
    storageBucket: 'rohan-e935d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLvbls4ym-wJouUf51IJRxvPEVEVvqOfs',
    appId: '1:513749196603:android:75b1a9ecb65d1f25d9a11e',
    messagingSenderId: '513749196603',
    projectId: 'rohan-e935d',
    storageBucket: 'rohan-e935d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAi5JBEi8RN0xLy5N6ujLT1rgoSHd9HUWw',
    appId: '1:513749196603:ios:0b9745a6518d5c83d9a11e',
    messagingSenderId: '513749196603',
    projectId: 'rohan-e935d',
    storageBucket: 'rohan-e935d.firebasestorage.app',
    iosBundleId: 'com.rohanatmaraksha.rohanAtmaraksha',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAi5JBEi8RN0xLy5N6ujLT1rgoSHd9HUWw',
    appId: '1:513749196603:ios:0b9745a6518d5c83d9a11e',
    messagingSenderId: '513749196603',
    projectId: 'rohan-e935d',
    storageBucket: 'rohan-e935d.firebasestorage.app',
    iosBundleId: 'com.rohanatmaraksha.rohanAtmaraksha',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3BV-h70h9uUA81qupCNrKkrlsnOnxazs',
    appId: '1:513749196603:web:b28c1904e89fd4d8d9a11e',
    messagingSenderId: '513749196603',
    projectId: 'rohan-e935d',
    authDomain: 'rohan-e935d.firebaseapp.com',
    storageBucket: 'rohan-e935d.firebasestorage.app',
  );
}
