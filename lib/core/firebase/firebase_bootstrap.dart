import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:habi/firebase_options.dart';

bool _isFirebaseAvailable = false;

bool get isFirebaseAvailable => _isFirebaseAvailable;

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _isFirebaseAvailable = true;
  } on Object catch (error, stackTrace) {
    _isFirebaseAvailable = false;
    debugPrint('Firebase is not configured yet: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> ensureFirebaseSignedIn() async {
  final auth = FirebaseAuth.instance;
  if (auth.currentUser != null) return;
  await auth.signInAnonymously();
}
