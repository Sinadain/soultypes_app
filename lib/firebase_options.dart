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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyADn_xiIJNJbJ4dHdEHBzbN6Qj5eQfHtMs',
    appId: '1:201784150710:web:8ed7e695a1f53aa6a47417',
    messagingSenderId: '201784150710',
    projectId: 'soultypes-app',
    authDomain: 'soultypes-app.firebaseapp.com',
    storageBucket: 'soultypes-app.firebasestorage.app',
    measurementId: 'G-CG8ZX72G80',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRMsVo7dIGvsGHgxqJlfs3g-VTumDIgqU',
    appId: '1:201784150710:android:a51b6aa4e0635efaa47417',
    messagingSenderId: '201784150710',
    projectId: 'soultypes-app',
    storageBucket: 'soultypes-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2wJYilvuUJ6G6DP-epv1-WpgpyDq7QZY',
    appId: '1:201784150710:ios:197b7e443d119a37a47417',
    messagingSenderId: '201784150710',
    projectId: 'soultypes-app',
    storageBucket: 'soultypes-app.firebasestorage.app',
    iosBundleId: 'com.example.soultypesApp',
  );
}
