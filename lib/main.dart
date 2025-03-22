import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/theme.dart';
import 'core/config/navigation.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
    // Still run the app even if Firebase fails to initialize
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SoulTypes',
      theme: AppTheme.lightTheme,
      routerConfig: AppNavigation.router,
    );
  }
}
