import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/dashboard/widgets/active_chores_section.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_events_section.dart';

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
    return Column(
      spacing: AppConstants.spacingMD,
      children: [
        _DashboardToolbar(now: _now),
        Row(
          spacing: AppConstants.spacingMD,
          children: [
            ActiveChoresSection().expanded(flex: 2),
            UpcomingEventsSection().expanded(flex: 1),
          ],
        ).expanded(),
      ],
    );
  }
}

class _DashboardToolbar extends StatelessWidget {
  final DateTime now;

  const _DashboardToolbar({required this.now});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              _dateLabel(now),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            _timeLabel(now),
            style: context.textTheme.displaySmall?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w800,
              height: 0.95,
            ),
          ),
        ],
      ),
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
