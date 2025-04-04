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
    apiKey: 'AIzaSyBJi--tg-BoE48sB31ihBg3FDZ1-Hm_sQo',
    appId: '1:479978088143:web:500e4521468474b58739ba',
    messagingSenderId: '479978088143',
    projectId: 'ledgera---accounting-cla-ecd3c',
    authDomain: 'ledgera---accounting-cla-ecd3c.firebaseapp.com',
    storageBucket: 'ledgera---accounting-cla-ecd3c.firebasestorage.app',
    measurementId: 'G-7ZTD3314GH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzmNBiJm13Mol8i5ifdZnfpKePooHtdHM',
    appId: '1:479978088143:android:5765c80014e5cd0a8739ba',
    messagingSenderId: '479978088143',
    projectId: 'ledgera---accounting-cla-ecd3c',
    storageBucket: 'ledgera---accounting-cla-ecd3c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6eUPQBvLZY03nLEUErRNux2A3SrOJp7U',
    appId: '1:479978088143:ios:07793d5e4f85f1e28739ba',
    messagingSenderId: '479978088143',
    projectId: 'ledgera---accounting-cla-ecd3c',
    storageBucket: 'ledgera---accounting-cla-ecd3c.firebasestorage.app',
    iosBundleId: 'com.example.ledgeroom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6eUPQBvLZY03nLEUErRNux2A3SrOJp7U',
    appId: '1:479978088143:ios:07793d5e4f85f1e28739ba',
    messagingSenderId: '479978088143',
    projectId: 'ledgera---accounting-cla-ecd3c',
    storageBucket: 'ledgera---accounting-cla-ecd3c.firebasestorage.app',
    iosBundleId: 'com.example.ledgeroom',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBJi--tg-BoE48sB31ihBg3FDZ1-Hm_sQo',
    appId: '1:479978088143:web:d81e657544a4bae98739ba',
    messagingSenderId: '479978088143',
    projectId: 'ledgera---accounting-cla-ecd3c',
    authDomain: 'ledgera---accounting-cla-ecd3c.firebaseapp.com',
    storageBucket: 'ledgera---accounting-cla-ecd3c.firebasestorage.app',
    measurementId: 'G-RDDD27EBYP',
  );
}
