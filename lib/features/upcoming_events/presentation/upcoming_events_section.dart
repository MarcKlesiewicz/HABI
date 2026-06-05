import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/upcoming_events/application/upcoming_events_providers.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_event_visuals.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class UpcomingEventsSection extends ConsumerWidget {
  const UpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(upcomingEventsProvider);

    return AppSurface(
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
            child: eventsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Could not load events: $error')),
              data: (events) {
                final grouped = groupUpcomingEventsByDate(events);
                return events.isEmpty
                    ? const Center(child: Text('No upcoming events'))
                    : ListView.separated(
                        itemCount: grouped.length,
                        separatorBuilder: (_, _) => context.gapMD,
                        itemBuilder: (context, index) {
                          final entry = grouped.entries.elementAt(index);
                          return _EventDayGroup(
                            date: entry.key,
                            events: entry.value,
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDayGroup extends StatelessWidget {
  final DateTime date;
  final List<UpcomingEvent> events;

  const _EventDayGroup({required this.date, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatDateWithWeekday(date),
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        context.gapSM,
        GlassContainer(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: context.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              return _UpcomingEventTile(event: events[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _UpcomingEventTile extends StatelessWidget {
  final UpcomingEvent event;

  const _UpcomingEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = upcomingEventCategoryColor(context, event.category);

    return ListTile(
      minVerticalPadding: 10,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(upcomingEventCategoryIcon(event.category), size: 20),
      ),
      title: Text(
        event.title,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.secondary,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        [
          formatUpcomingEventTimeSpan(event),
          if (event.description != null) event.description!,
        ].join(' - '),
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Chip(
        label: Text(upcomingEventCategoryLabel(event.category)),
        backgroundColor: color.withValues(alpha: 0.12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        labelStyle: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _formatDateWithWeekday(DateTime date) {
  return formatEventDateWithWeekday(date);
}
