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
    apiKey: 'AIzaSyCOrvxvISKXT1g-159MgSG2nm1pF0H2TmY',
    appId: '1:27279437235:web:9e46054b82dd856fc4efc6',
    messagingSenderId: '27279437235',
    projectId: 'billyapp-a6321',
    authDomain: 'billyapp-a6321.firebaseapp.com',
    storageBucket: 'billyapp-a6321.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe8DnXSABkj-C4eKzGwMPYFqHZ8yVj4Rc',
    appId: '1:27279437235:android:096f350253ac8420c4efc6',
    messagingSenderId: '27279437235',
    projectId: 'billyapp-a6321',
    storageBucket: 'billyapp-a6321.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUIakqmL0WpuJFXUm0scV1ndpen0__GOI',
    appId: '1:27279437235:ios:583e324e4781b26bc4efc6',
    messagingSenderId: '27279437235',
    projectId: 'billyapp-a6321',
    storageBucket: 'billyapp-a6321.appspot.com',
    iosClientId: '27279437235-o1rr6iqjir03e17obl9l1t6rtr7222db.apps.googleusercontent.com',
    iosBundleId: 'com.example.billy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUIakqmL0WpuJFXUm0scV1ndpen0__GOI',
    appId: '1:27279437235:ios:583e324e4781b26bc4efc6',
    messagingSenderId: '27279437235',
    projectId: 'billyapp-a6321',
    storageBucket: 'billyapp-a6321.appspot.com',
    iosClientId: '27279437235-o1rr6iqjir03e17obl9l1t6rtr7222db.apps.googleusercontent.com',
    iosBundleId: 'com.example.billy',
  );
}
