// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static String _getApiKey() {
    final apiKey = dotenv.env['FIREBASE_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      // Fallback for development (should not be used in production)
      return 'AIzaSyAxQ53DQzyEkKXjo3Ry2B9pcTMvcyk4d5o';
    }
    return apiKey;
  }

  static FirebaseOptions get web {
    return FirebaseOptions(
      apiKey: _getApiKey(),
      appId: dotenv.env['FIREBASE_APP_ID_WEB'] ?? '1:703941154390:web:43dfeaf2f6a0495e004df7',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '703941154390',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'repsync-app-8685c',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'repsync-app-8685c.firebaseapp.com',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'repsync-app-8685c.firebasestorage.app',
    );
  }

  static FirebaseOptions get android {
    return FirebaseOptions(
      apiKey: _getApiKey(),
      appId: dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '1:703941154390:android:43dfeaf2f6a0495e004df7',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '703941154390',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'repsync-app-8685c',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'repsync-app-8685c.firebaseapp.com',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'repsync-app-8685c.firebasestorage.app',
    );
  }

  static FirebaseOptions get ios {
    return FirebaseOptions(
      apiKey: _getApiKey(),
      appId: dotenv.env['FIREBASE_APP_ID_IOS'] ?? '1:703941154390:ios:43dfeaf2f6a0495e004df7',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '703941154390',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'repsync-app-8685c',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'repsync-app-8685c.firebaseapp.com',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'repsync-app-8685c.firebasestorage.app',
      iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? 'com.example.flutterRepsyncApp',
    );
  }
}
