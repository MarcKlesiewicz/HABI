import 'package:flutter/material.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme, // Light mode theme
      darkTheme: AppTheme.darkTheme, // Dark mode theme
      themeMode: ThemeMode.system, // Follows system setting
      routerConfig: router,
    );
  }
}
