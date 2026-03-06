// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Firebase options for RepSync Metronome
/// 
/// Note: All configuration values are hardcoded for development.
/// For production, use proper Firebase configuration:
/// - Android: google-services.json
/// - iOS: GoogleService-Info.plist
/// - Web: Firebase config in web/index.html
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static FirebaseOptions get web {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAxQ53DQzyEkKXjo3Ry2B9pcTMvcyk4d5o',
      appId: '1:703941154390:web:43dfeaf2f6a0495e004df7',
      messagingSenderId: '703941154390',
      projectId: 'repsync-app-8685c',
      authDomain: 'repsync-app-8685c.firebaseapp.com',
      storageBucket: 'repsync-app-8685c.firebasestorage.app',
    );
  }

  static FirebaseOptions get android {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAxQ53DQzyEkKXjo3Ry2B9pcTMvcyk4d5o',
      appId: '1:703941154390:android:43dfeaf2f6a0495e004df7',
      messagingSenderId: '703941154390',
      projectId: 'repsync-app-8685c',
      authDomain: 'repsync-app-8685c.firebaseapp.com',
      storageBucket: 'repsync-app-8685c.firebasestorage.app',
    );
  }

  static FirebaseOptions get ios {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAxQ53DQzyEkKXjo3Ry2B9pcTMvcyk4d5o',
      appId: '1:703941154390:ios:43dfeaf2f6a0495e004df7',
      messagingSenderId: '703941154390',
      projectId: 'repsync-app-8685c',
      authDomain: 'repsync-app-8685c.firebaseapp.com',
      storageBucket: 'repsync-app-8685c.firebasestorage.app',
      iosBundleId: 'com.example.flutterRepsyncApp',
    );
  }
}
