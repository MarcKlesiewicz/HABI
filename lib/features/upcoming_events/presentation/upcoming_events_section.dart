import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/features/upcoming_events/application/upcoming_events_providers.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_event_visuals.dart';
import 'package:habi/shared/widgets/app_card.dart';

class UpcomingEventsSection extends ConsumerWidget {
  const UpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(upcomingEventsProvider);
    final theme = FTheme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Events',
            style: theme.typography.xl.copyWith(
              color: theme.colors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMD),
          Expanded(
            child: eventsState.when(
              loading: () => const Center(child: FCircularProgress()),
              error: (error, _) => Center(
                child: FAlert(
                  style: FAlertStyle.destructive(),
                  title: const Text('Could not load events'),
                  subtitle: Text(error.toString()),
                ),
              ),
              data: (events) {
                if (events.isEmpty) {
                  return const Center(
                    child: FAlert(
                      icon: Icon(Icons.event_available_outlined),
                      title: Text('Nothing scheduled'),
                      subtitle: Text('There are no upcoming events.'),
                    ),
                  );
                }

                final grouped = groupUpcomingEventsByDate(events);
                return ListView.separated(
                  itemCount: grouped.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppConstants.spacingMD),
                  itemBuilder: (context, index) {
                    final entry = grouped.entries.elementAt(index);
                    return _EventDayGroup(date: entry.key, events: entry.value);
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
  const _EventDayGroup({required this.date, required this.events});

  final DateTime date;
  final List<UpcomingEvent> events;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatEventDateWithWeekday(date),
          style: theme.typography.sm.copyWith(
            color: theme.colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSM),
        FItemGroup(
          divider: FItemDivider.full,
          semanticsLabel: 'Events on ${formatEventDateWithWeekday(date)}',
          children: [for (final event in events) _eventItem(context, event)],
        ),
      ],
    );
  }

  FItem _eventItem(BuildContext context, UpcomingEvent event) {
    final theme = FTheme.of(context);

    return FItem(
      title: Text(
        event.title,
        style: theme.typography.base.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: event.description == null
          ? null
          : Text(
              event.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
      prefix: _EventIcon(event: event),
      details: FBadge(
        style: FBadgeStyle.outline(),
        child: Text(formatUpcomingEventTimeSpan(event)),
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.event});

  final UpcomingEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final color = upcomingEventCategoryColor(context, event.category);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: theme.style.borderRadius,
      ),
      child: SizedBox.square(
        dimension: 40,
        child: Center(
          child: UpcomingEventCategoryIcon(category: event.category, size: 19),
        ),
      ),
    );
  }
}
