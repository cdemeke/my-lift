import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'firebase_options.dart';

/// Main entry point for the MyLift app.
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for mobile)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open Hive boxes for caching
  await _initializeHiveBoxes();

  // Run the app with Riverpod
  runApp(
    const ProviderScope(
      child: MyLiftApp(),
    ),
  );
}

/// Initialize Hive boxes for local storage.
Future<void> _initializeHiveBoxes() async {
  // Workouts cache box
  await Hive.openBox<String>('workouts_cache');

  // Exercises cache box
  await Hive.openBox<String>('exercises_cache');

  // Pending sync box (for offline data)
  await Hive.openBox<String>('pending_sync');

  // User preferences box
  await Hive.openBox<dynamic>('user_preferences');
}
