import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';

const airbnbIconAsset = 'lib/assets/svg/airbnb-icon.svg';

IconData upcomingEventCategoryIcon(UpcomingEventCategory category) {
  return switch (category) {
    UpcomingEventCategory.airbnb => Icons.home_outlined,
    UpcomingEventCategory.appointment => Icons.event_available_outlined,
    UpcomingEventCategory.birthday => Icons.cake_outlined,
    UpcomingEventCategory.personal => Icons.person_outline,
    UpcomingEventCategory.other => Icons.event_outlined,
  };
}

class UpcomingEventCategoryIcon extends StatelessWidget {
  final UpcomingEventCategory category;
  final double size;

  const UpcomingEventCategoryIcon({
    super.key,
    required this.category,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (category == UpcomingEventCategory.airbnb) {
      return SvgPicture.asset(airbnbIconAsset, width: size, height: size);
    }

    return Icon(upcomingEventCategoryIcon(category), size: size);
  }
}

String upcomingEventCategoryLabel(UpcomingEventCategory category) {
  return switch (category) {
    UpcomingEventCategory.airbnb => 'Airbnb',
    UpcomingEventCategory.appointment => 'Appointment',
    UpcomingEventCategory.birthday => 'Birthday',
    UpcomingEventCategory.personal => 'Personal',
    UpcomingEventCategory.other => 'Other',
  };
}

Color upcomingEventCategoryColor(
  BuildContext context,
  UpcomingEventCategory category,
) {
  return switch (category) {
    UpcomingEventCategory.airbnb => Colors.pink,
    UpcomingEventCategory.appointment => context.colorScheme.primary,
    UpcomingEventCategory.birthday => Colors.red,
    UpcomingEventCategory.personal => context.colorScheme.tertiary,
    UpcomingEventCategory.other => context.colorScheme.secondary,
  };
}

String formatUpcomingEventTimeSpan(UpcomingEvent event) {
  if (event.endsAt == null) return formatEventTime(event.startsAt);
  return '${formatEventTime(event.startsAt)} - ${formatEventTime(event.endsAt!)}';
}

String formatEventTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}

String formatEventDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatEventDateWithWeekday(DateTime date) {
  return '${weekdayLabel(date)}, ${date.day}/${date.month}';
}

String monthLabel(DateTime date) {
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

  return months[date.month - 1];
}

String weekdayLabel(DateTime date) {
  const weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  return weekdays[date.weekday - 1];
}
