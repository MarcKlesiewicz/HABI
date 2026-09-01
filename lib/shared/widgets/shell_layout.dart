import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/shared/widgets/sidebar_menu.dart';

class ShellLayout extends StatefulWidget {
  const ShellLayout({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  State<ShellLayout> createState() => _ShellLayoutState();
}

class _ShellLayoutState extends State<ShellLayout> {
  late DateTime _now;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ShellHeader(
                            title: widget.title,
                            now: _now,
                            compact: true,
                          ),
                          const SizedBox(height: AppConstants.spacingMD),
                          Expanded(child: widget.child),
                        ],
                      ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ShellHeader(title: widget.title, now: _now),
                        const SizedBox(height: AppConstants.spacingLG),
                        Expanded(child: widget.child),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShellHeader extends StatelessWidget {
  const _ShellHeader({
    required this.title,
    required this.now,
    this.compact = false,
  });

  final String title;
  final DateTime now;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final titleStyle = compact ? theme.typography.xl2 : theme.typography.xl3;

    return FHeader(
      style: (style) => style.copyWith(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXS,
          vertical: AppConstants.spacingXS,
        ),
        titleTextStyle: titleStyle.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            _dateLabel(now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      suffixes: [
        Text(
          _timeLabel(now),
          style: titleStyle.copyWith(
            color: theme.colors.foreground,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ],
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

String _timeLabel(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}

String _dateLabel(DateTime dateTime) {
  const weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${weekdays[dateTime.weekday - 1]}, ${dateTime.day} '
      '${months[dateTime.month - 1]}';
}
