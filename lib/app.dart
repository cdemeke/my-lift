import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/services/settings_service.dart';

/// Root widget for the MyLift app.
class MyLiftApp extends ConsumerWidget {
  const MyLiftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get router from provider
    final router = ref.watch(routerProvider);

    // Watch dark mode setting
    final isDarkMode = ref.watch(darkModeProvider);

    return MaterialApp.router(
      // App metadata
      title: 'MyLift',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Router configuration
      routerConfig: router,

      // Builder for global overlays
      builder: (context, child) {
        return MediaQuery(
          // Prevent text scaling from breaking layouts
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
