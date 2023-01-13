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
    apiKey: 'AIzaSyCcnpenAl_LRoQOxFuhYYay1-Kvi8hZEGE',
    appId: '1:945647164575:web:8f77492f65d667ac7596aa',
    messagingSenderId: '945647164575',
    projectId: 'assignments-66459',
    authDomain: 'assignments-66459.firebaseapp.com',
    storageBucket: 'assignments-66459.appspot.com',
    measurementId: 'G-9T4DF9RTW9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBA2njF3dW5hshzZ9mlTzppL-zXSNaGWEI',
    appId: '1:945647164575:android:2f1beba85c12e23b7596aa',
    messagingSenderId: '945647164575',
    projectId: 'assignments-66459',
    storageBucket: 'assignments-66459.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDADfcPb5_EcsH8uZoTjfc2_scD46L4v0c',
    appId: '1:945647164575:ios:9cb151ebca67e9417596aa',
    messagingSenderId: '945647164575',
    projectId: 'assignments-66459',
    storageBucket: 'assignments-66459.appspot.com',
    androidClientId: '945647164575-5b7taq3bmocjoe14alo735i0h70kael1.apps.googleusercontent.com',
    iosClientId: '945647164575-0pok064mknbkf4ghsj2d9qrof0l9mdrh.apps.googleusercontent.com',
    iosBundleId: 'com.sixteenbrains.assignments',
  );
}