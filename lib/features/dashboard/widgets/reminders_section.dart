import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/app_theme.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/shared/widgets/glass_container.dart';

// helpers that are used by the widget and by the tests

/// Groups [events] by their calendar date (time portion ignored).  The lists
/// in the resulting map are sorted by `dateTime`.
Map<DateTime, List<CalendarEvent>> groupEventsByDate(
  List<CalendarEvent> events,
) {
  final sorted = List<CalendarEvent>.from(events)
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  final Map<DateTime, List<CalendarEvent>> groups = {};
  for (final event in sorted) {
    final key = DateTime(
      event.dateTime.year,
      event.dateTime.month,
      event.dateTime.day,
    );
    groups.putIfAbsent(key, () => []).add(event);
  }
  return groups;
}

String formatDateWithWeekday(DateTime date) {
  const weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  // const months = <String>[
  //   'January',
  //   'February',
  //   'March',
  //   'April',
  //   'May',
  //   'June',
  //   'July',
  //   'August',
  //   'September',
  //   'October',
  //   'November',
  //   'December',
  // ];

  final weekday = weekdays[date.weekday - 1];
  // final month = months[date.month - 1];
  return '$weekday, ${date.day}/${date.month}';
}

class RemaindersSection extends StatefulWidget {
  const RemaindersSection({super.key});

  @override
  State<RemaindersSection> createState() => _RemaindersSectionState();
}

class _RemaindersSectionState extends State<RemaindersSection> {
  final List<CalendarEvent> events = [
    CalendarEvent(
      title: 'Moms birthday',
      dateTime: DateTime(2026, 6, 15, 10, 0),
      duration: Duration(hours: 1),
      label: EventLabel.birthday,
    ),
    CalendarEvent(
      title: 'Project Meeting',
      dateTime: DateTime(2026, 6, 15, 14, 30),
      duration: Duration(hours: 2),
      label: EventLabel.mathilde,
    ),
    CalendarEvent(
      title: 'Dentist Appointment',
      dateTime: DateTime(2026, 6, 17, 9, 0),
      duration: Duration(minutes: 30),
      label: EventLabel.marc,
    ),
    CalendarEvent(
      title: 'Airbnb Check-in',
      dateTime: DateTime(2026, 6, 17, 10, 0),
      label: EventLabel.airbnb,
      description: '1 persion, 3 nights',
    ),
    CalendarEvent(
      title: 'Dentist Appointment',
      dateTime: DateTime(2026, 6, 20, 9, 0),
      duration: Duration(minutes: 30),
    ),
    CalendarEvent(
      title: 'Dentist Appointment',
      dateTime: DateTime(2026, 6, 18, 9, 0),
      duration: Duration(minutes: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = groupEventsByDate(events);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.black),
      ),
      padding: context.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Events',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          context.gapMD,
          Expanded(
            child: ListView(
              children: grouped.entries.map((entry) {
                final date = entry.key;
                final dayEvents = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDateWithWeekday(date),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: context.colorScheme.secondary,
                            offset: Offset(1, 1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    context.gapSM,
                    ...dayEvents.expand(
                      (event) => [
                        _buildEventTile(context, event),
                        context.gapSM,
                      ],
                    ),
                    context.gapMD,
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, CalendarEvent event) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (event.getTimeSpan() != null)
                  Text(
                    event.getTimeSpan()!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (event.description != null)
                  Text(
                    event.description!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ).paddingAll(8),
          ),
        ),
        if (event.label != null)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: event.getLabelColor(context),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radiusSM),
                  topRight: Radius.circular(AppConstants.radiusSM),
                ),
                border: Border.all(
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                  width: 2,
                ),
              ),
              child:
                  Text(
                    event.label.toString().split('.').last.toUpperCase(),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingSymmetric(
                    horizontal: AppConstants.spacingSM,
                    vertical: 0,
                  ),
            ),
          ),
      ],
    );
  }
}

class CalendarEvent {
  final String title;
  final DateTime dateTime;
  final String? description;
  final Duration? duration;
  final EventLabel? label;

  CalendarEvent({
    required this.title,
    required this.dateTime,
    this.description,
    this.duration,
    this.label,
  });

  /// Returns the end time of the event
  DateTime get endDateTime => dateTime.add(duration!);

  /// Returns formatted time span like "10:00 - 11:00"
  String? getTimeSpan() {
    if (duration == null) return null;
    final start = _formatTime(dateTime);
    final end = _formatTime(endDateTime);
    return '$start - $end';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color getLabelColor(BuildContext context) {
    switch (label) {
      case EventLabel.marc:
        return context.colorScheme.customDarkGreen;
      case EventLabel.mathilde:
        return context.colorScheme.primary;
      case EventLabel.cody:
        return context.colorScheme.tertiary;
      case EventLabel.birthday:
        return Colors.red;
      case EventLabel.airbnb:
        return Colors.pink;
      case EventLabel.other:
      default:
        return context.colorScheme.surface;
    }
  }
}

enum EventLabel { marc, mathilde, cody, birthday, airbnb, other }
