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
    apiKey: 'AIzaSyAtkHZbcquKo0E8oekNscFwhICENvaXeLA',
    appId: '1:469023484530:web:2406ad872a868738f4f0eb',
    messagingSenderId: '469023484530',
    projectId: 'chatapp-e5856',
    authDomain: 'chatapp-e5856.firebaseapp.com',
    storageBucket: 'chatapp-e5856.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbhQDZNEG89FcBeB-PFt7TmIWmEaZ8Yf8',
    appId: '1:469023484530:android:765591cd75ce6465f4f0eb',
    messagingSenderId: '469023484530',
    projectId: 'chatapp-e5856',
    storageBucket: 'chatapp-e5856.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5FnGgH6-R6xX-AsYASufUB4nIPDFD-Mo',
    appId: '1:469023484530:ios:e64dfb0ffe4ab0d9f4f0eb',
    messagingSenderId: '469023484530',
    projectId: 'chatapp-e5856',
    storageBucket: 'chatapp-e5856.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5FnGgH6-R6xX-AsYASufUB4nIPDFD-Mo',
    appId: '1:469023484530:ios:e64dfb0ffe4ab0d9f4f0eb',
    messagingSenderId: '469023484530',
    projectId: 'chatapp-e5856',
    storageBucket: 'chatapp-e5856.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtkHZbcquKo0E8oekNscFwhICENvaXeLA',
    appId: '1:469023484530:web:7e78aac989765fd3f4f0eb',
    messagingSenderId: '469023484530',
    projectId: 'chatapp-e5856',
    authDomain: 'chatapp-e5856.firebaseapp.com',
    storageBucket: 'chatapp-e5856.appspot.com',
  );
}
