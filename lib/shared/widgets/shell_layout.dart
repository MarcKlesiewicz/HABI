import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/shared/widgets/sidebar_menu.dart';

class ShellLayout extends StatelessWidget {
  final Widget child;

  const ShellLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 720) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: child,
                    ),
                  ),
                  const _CompactNavigation(),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              child: Row(
                spacing: AppConstants.spacingLG,
                children: [
                  const SidebarMenu(),
                  Expanded(child: child),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompactNavigation extends StatelessWidget {
  const _CompactNavigation();

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final paths = [
      AppRoutePath.dashboard,
      AppRoutePath.airbnb,
      AppRoutePath.calendar,
      AppRoutePath.chores,
    ];
    final selectedIndex = paths.indexOf(path).clamp(0, paths.length - 1);

    return FBottomNavigationBar(
      index: selectedIndex,
      onChange: (index) => context.go(paths[index]),
      children: const [
        FBottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: Text('Home'),
        ),
        FBottomNavigationBarItem(
          icon: Icon(Icons.bed_outlined),
          label: Text('Airbnb'),
        ),
        FBottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: Text('Calendar'),
        ),
        FBottomNavigationBarItem(
          icon: Icon(Icons.cleaning_services_outlined),
          label: Text('Chores'),
        ),
      ],
    );
  }
}
