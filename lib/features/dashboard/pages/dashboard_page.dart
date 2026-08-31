import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/features/dashboard/widgets/active_chores_section.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_events_section.dart';
import 'package:habi/shared/widgets/app_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DateTime _now;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < AppConstants.breakpointTablet;

        if (compact) {
          return ListView(
            children: [
              _DashboardToolbar(now: _now),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(
                height: 280,
                child: _DashboardPlaceholderCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Highlights',
                  subtitle: 'A focused overview of your home will live here.',
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(
                height: 240,
                child: _DashboardPlaceholderCard(
                  icon: Icons.bed_outlined,
                  title: 'Next Airbnb',
                  subtitle: 'Your next reservation will live here.',
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(height: 440, child: ActiveChoresSection()),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(height: 440, child: UpcomingEventsSection()),
            ],
          );
        }

        return Column(
          spacing: AppConstants.spacingLG,
          children: [
            _DashboardToolbar(now: _now),
            Expanded(
              child: Row(
                spacing: AppConstants.spacingLG,
                children: const [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppConstants.spacingLG,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _DashboardPlaceholderCard(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Highlights',
                            subtitle:
                                'A focused overview of your home will live here.',
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            spacing: AppConstants.spacingLG,
                            children: [
                              Expanded(
                                child: _DashboardPlaceholderCard(
                                  icon: Icons.bed_outlined,
                                  title: 'Next Airbnb',
                                  subtitle:
                                      'Your next reservation will live here.',
                                ),
                              ),
                              Expanded(child: ActiveChoresSection()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: UpcomingEventsSection()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardPlaceholderCard extends StatelessWidget {
  const _DashboardPlaceholderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colors.secondary,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
            child: SizedBox.square(
              dimension: AppConstants.buttonHeight,
              child: Icon(
                icon,
                color: theme.colors.secondaryForeground,
                semanticLabel: title,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: theme.typography.xl.copyWith(
              color: theme.colors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            subtitle,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardToolbar extends StatelessWidget {
  final DateTime now;

  const _DashboardToolbar({required this.now});

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FHeader(
      style: (style) => style.copyWith(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXS,
          vertical: AppConstants.spacingXS,
        ),
        titleTextStyle: theme.typography.xl3.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Home'),
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
          style: theme.typography.xl3.copyWith(
            color: theme.colors.foreground,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
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
