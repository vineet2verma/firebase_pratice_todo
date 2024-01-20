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
    apiKey: 'AIzaSyAfkq8l1VmXE8TwdA3CUscc4T2DRz6NMO8',
    appId: '1:994954094093:web:4fd99c86b2d99088095744',
    messagingSenderId: '994954094093',
    projectId: 'fir-pratice-app-4e5ae',
    authDomain: 'fir-pratice-app-4e5ae.firebaseapp.com',
    storageBucket: 'fir-pratice-app-4e5ae.appspot.com',
    measurementId: 'G-NGX5RQVDZF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDY_u2ecGbs36fcDDsIExyaw0WF62EReic',
    appId: '1:994954094093:android:91f5af7bf4a54a10095744',
    messagingSenderId: '994954094093',
    projectId: 'fir-pratice-app-4e5ae',
    storageBucket: 'fir-pratice-app-4e5ae.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQWKc1gZlYOMtPaFgVw_mPLHDJYOUzyQU',
    appId: '1:994954094093:ios:a615d3679aa3ae70095744',
    messagingSenderId: '994954094093',
    projectId: 'fir-pratice-app-4e5ae',
    storageBucket: 'fir-pratice-app-4e5ae.appspot.com',
    iosBundleId: 'com.example.firebasePraticeTodo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQWKc1gZlYOMtPaFgVw_mPLHDJYOUzyQU',
    appId: '1:994954094093:ios:a615d3679aa3ae70095744',
    messagingSenderId: '994954094093',
    projectId: 'fir-pratice-app-4e5ae',
    storageBucket: 'fir-pratice-app-4e5ae.appspot.com',
    iosBundleId: 'com.example.firebasePraticeTodo',
  );
}