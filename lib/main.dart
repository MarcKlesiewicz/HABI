import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_forui_theme.dart';
import 'package:habi/config/theme/app_theme.dart';
import 'package:habi/core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Habi',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      builder: (context, child) {
        final theme = Theme.brightnessOf(context) == Brightness.dark
            ? AppForuiTheme.dark
            : AppForuiTheme.light;
        return FTheme(data: theme, child: child!);
      },
    );
  }
}
