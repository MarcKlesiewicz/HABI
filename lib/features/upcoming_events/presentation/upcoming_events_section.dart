import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/config/theme/app_constants.dart';
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          separatorBuilder: (_, _) => context.gapSM,
          itemBuilder: (context, index) {
            return _UpcomingEventTile(event: events[index]);
          },
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

    return Material(
      color: context.colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: context.radiusSM,
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 3, color: color),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: context.radiusSM,
                ),
                child: Center(
                  child: UpcomingEventCategoryIcon(
                    category: event.category,
                    size: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.spacingSM,
                  right: AppConstants.spacingSM,
                  bottom: AppConstants.spacingSM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        context.gapSM,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSM,
                            vertical: AppConstants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainerHighest,
                            borderRadius: context.radiusXS,
                          ),
                          child: Text(
                            formatUpcomingEventTimeSpan(event),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (event.description != null) ...[
                      context.gapXS,
                      Text(
                        event.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateWithWeekday(DateTime date) {
  return formatEventDateWithWeekday(date);
}
