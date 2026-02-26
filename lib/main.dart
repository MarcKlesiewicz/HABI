import 'package:flutter/material.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/theme.dart';
import 'package:habi/config/theme/text_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(
      context,
      "Inter",
      "Atkinson Hyperlegible",
    );

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: theme.light(),
      routerConfig: router,
    );
  }
}
