import 'package:go_router/go_router.dart';
import 'package:habi/features/airbnb/airbnb_page.dart';
import 'package:habi/features/dashboard/pages/dashboard_page.dart';
import 'package:habi/shared/widgets/shell_layout.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellLayout(child: child),
      routes: [
        GoRoute(
          path: AppRoutePath.dashboard,
          builder: (context, state) => DashboardPage(),
        ),
        GoRoute(
          path: AppRoutePath.airbnb,
          builder: (context, state) => const AirBnbPage(),
        ),
      ],
    ),
  ],
);

class AppRoutePath {
  static const String dashboard = '/';
  static const String airbnb = '/airbnb';
}
