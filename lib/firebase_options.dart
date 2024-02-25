// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDlaBBOPTQpTRkkAfeJw_xmmR9tVoiEZjU',
    appId: '1:91423500395:web:51c6e683f87d7389dea92e',
    messagingSenderId: '91423500395',
    projectId: 'studentjo-57f60',
    authDomain: 'studentjo-57f60.firebaseapp.com',
    storageBucket: 'studentjo-57f60.appspot.com',
    measurementId: 'G-2F6G8D0FFR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5id4ubJ_x0ETNkapIR2oTYlhkGVHzz8o',
    appId: '1:91423500395:android:75cb0dff330e4290dea92e',
    messagingSenderId: '91423500395',
    projectId: 'studentjo-57f60',
    storageBucket: 'studentjo-57f60.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA88qRoUk2aIf9UEMkn852dg4apsQUzIOc',
    appId: '1:91423500395:ios:eda74b2da034fafcdea92e',
    messagingSenderId: '91423500395',
    projectId: 'studentjo-57f60',
    storageBucket: 'studentjo-57f60.appspot.com',
    iosBundleId: 'com.masterung.studentjo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA88qRoUk2aIf9UEMkn852dg4apsQUzIOc',
    appId: '1:91423500395:ios:15fd2d868a43a642dea92e',
    messagingSenderId: '91423500395',
    projectId: 'studentjo-57f60',
    storageBucket: 'studentjo-57f60.appspot.com',
    iosBundleId: 'com.masterung.studentjo.RunnerTests',
  );
}