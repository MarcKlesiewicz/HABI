import 'package:go_router/go_router.dart';
import 'package:habi/features/airbnb/airbnb_page.dart';
import 'package:habi/features/chores/pages/chores_page.dart';
import 'package:habi/features/dashboard/pages/dashboard_page.dart';
import 'package:habi/features/upcoming_events/presentation/calendar_page.dart';
import 'package:habi/shared/widgets/shell_layout.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellLayout(
        title: AppRoutePath.titleFor(state.uri.path),
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutePath.dashboard,
          builder: (context, state) => DashboardPage(),
        ),
        GoRoute(
          path: AppRoutePath.airbnb,
          builder: (context, state) => const AirBnbPage(),
        ),
        GoRoute(
          path: AppRoutePath.calendar,
          builder: (context, state) => const CalendarPage(),
        ),
        GoRoute(
          path: AppRoutePath.chores,
          builder: (context, state) => const ChoresPage(),
        ),
      ],
    ),
  ],
);

class AppRoutePath {
  static const String dashboard = '/';
  static const String airbnb = '/airbnb';
  static const String calendar = '/calendar';
  static const String chores = '/chores';

  static String titleFor(String path) => switch (path) {
    dashboard => 'Home',
    airbnb => 'Airbnb',
    calendar => 'Calendar',
    chores => 'Chores',
    _ => 'Habi',
  };
}
