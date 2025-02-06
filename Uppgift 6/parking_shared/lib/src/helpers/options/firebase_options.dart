import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBo49difNHzRFTc7SL9CsVt2owQrqXpV2E',
    appId: '1:1059671592375:web:9492d6deb0dc3cff84ec32',
    messagingSenderId: '1059671592375',
    projectId: 'serverparking-9de55',
    authDomain: 'serverparking-9de55.firebaseapp.com',
    databaseURL:
        'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'serverparking-9de55.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhGwyn8QYsmxlT7qW3GltoGemRVQaFrgE',
    appId: '1:1059671592375:android:da09b2498cf239c384ec32',
    messagingSenderId: '1059671592375',
    projectId: 'serverparking-9de55',
    databaseURL:
        'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'serverparking-9de55.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDy0oCS2HMVb4ahIanQ6xh-HD3y4G3fvKU',
    appId: '1:1059671592375:ios:366842f145f14d8c84ec32',
    messagingSenderId: '1059671592375',
    projectId: 'serverparking-9de55',
    databaseURL:
        'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'serverparking-9de55.firebasestorage.app',
    iosBundleId: 'com.example.parkingServer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDy0oCS2HMVb4ahIanQ6xh-HD3y4G3fvKU',
    appId: '1:1059671592375:ios:366842f145f14d8c84ec32',
    messagingSenderId: '1059671592375',
    projectId: 'serverparking-9de55',
    databaseURL:
        'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'serverparking-9de55.firebasestorage.app',
    iosBundleId: 'com.example.parkingServer',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBo49difNHzRFTc7SL9CsVt2owQrqXpV2E',
    appId: '1:1059671592375:web:ca982b83134d8f5584ec32',
    messagingSenderId: '1059671592375',
    projectId: 'serverparking-9de55',
    authDomain: 'serverparking-9de55.firebaseapp.com',
    databaseURL:
        'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'serverparking-9de55.firebasestorage.app',
  );
}
