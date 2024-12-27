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
    apiKey: 'AIzaSyDdCI-WgQY-wJzJgGO3-VdVm1UBSSys4hc',
    appId: '1:690654373197:web:20ad235e3ed89c11064304',
    messagingSenderId: '690654373197',
    projectId: 'se7ety-562002',
    authDomain: 'se7ety-562002.firebaseapp.com',
    storageBucket: 'se7ety-562002.firebasestorage.app',
    measurementId: 'G-PQ5P3QQE0E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDC7zmJoSq1OYGrtYHNUC4chI2EnzH5ZYs',
    appId: '1:690654373197:android:9f3802b8126fb906064304',
    messagingSenderId: '690654373197',
    projectId: 'se7ety-562002',
    storageBucket: 'se7ety-562002.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDG7TELi90BlvkLLHpcDwUo-eMos70zyY0',
    appId: '1:690654373197:ios:f22b065fadeecbb6064304',
    messagingSenderId: '690654373197',
    projectId: 'se7ety-562002',
    storageBucket: 'se7ety-562002.firebasestorage.app',
    iosBundleId: 'com.example.se7ety',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDG7TELi90BlvkLLHpcDwUo-eMos70zyY0',
    appId: '1:690654373197:ios:f22b065fadeecbb6064304',
    messagingSenderId: '690654373197',
    projectId: 'se7ety-562002',
    storageBucket: 'se7ety-562002.firebasestorage.app',
    iosBundleId: 'com.example.se7ety',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdCI-WgQY-wJzJgGO3-VdVm1UBSSys4hc',
    appId: '1:690654373197:web:ea0965cb3ff32a7c064304',
    messagingSenderId: '690654373197',
    projectId: 'se7ety-562002',
    authDomain: 'se7ety-562002.firebaseapp.com',
    storageBucket: 'se7ety-562002.firebasestorage.app',
    measurementId: 'G-6RM8REC4YX',
  );
}
