import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/upcoming_events/application/upcoming_events_providers.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_event_visuals.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _visibleMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _visibleMonth = DateTime(today.year, today.month);
    _selectedDay = DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(calendarEventsProvider);

    return eventsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassContainer(
        isElevated: true,
        child: Center(child: Text('Could not load events: $error')),
      ),
      data: (events) {
        final eventsByDate = groupUpcomingEventsByDate(events);
        final selectedEvents = eventsByDate[_selectedDay] ?? const [];

        return Row(
          spacing: AppConstants.spacingMD,
          children: [
            AppSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CalendarHeader(
                    visibleMonth: _visibleMonth,
                    onAddEvent: () => _showEventDialog(
                      context,
                      ref,
                      initialDate: _selectedDay,
                    ),
                    onPreviousMonth: () => setState(() {
                      _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month - 1,
                      );
                    }),
                    onNextMonth: () => setState(() {
                      _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month + 1,
                      );
                    }),
                    onToday: () => setState(() {
                      final today = DateTime.now();
                      _visibleMonth = DateTime(today.year, today.month);
                      _selectedDay = DateTime(
                        today.year,
                        today.month,
                        today.day,
                      );
                    }),
                  ),
                  context.gapMD,
                  _WeekdayHeader(),
                  context.gapSM,
                  Expanded(
                    child: _MonthGrid(
                      visibleMonth: _visibleMonth,
                      selectedDay: _selectedDay,
                      eventsByDate: eventsByDate,
                      onDaySelected: (day) => setState(() {
                        _selectedDay = day;
                        _visibleMonth = DateTime(day.year, day.month);
                      }),
                    ),
                  ),
                ],
              ),
            ).expanded(flex: 3),
            _SelectedDayPanel(
              selectedDay: _selectedDay,
              events: selectedEvents,
              onAddEvent: () =>
                  _showEventDialog(context, ref, initialDate: _selectedDay),
              onEditEvent: (event) => _showEventDialog(
                context,
                ref,
                event: event,
                initialDate: event.startsAt,
              ),
              onDeleteEvent: (event) =>
                  _confirmDeleteEvent(context, ref, event),
            ).expanded(flex: 1),
          ],
        );
      },
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime visibleMonth;
  final VoidCallback onAddEvent;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onToday;

  const _CalendarHeader({
    required this.visibleMonth,
    required this.onAddEvent,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${monthLabel(visibleMonth)} ${visibleMonth.year}',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: onAddEvent,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add event'),
        ),
        context.gapSM,
        OutlinedButton.icon(
          onPressed: onToday,
          icon: const Icon(Icons.today_outlined, size: 18),
          label: const Text('Today'),
        ),
        context.gapSM,
        IconButton.filledTonal(
          tooltip: 'Previous month',
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left),
        ),
        context.gapSM,
        IconButton.filledTonal(
          tooltip: 'Next month',
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const weekdays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children: weekdays
          .map(
            (weekday) => Expanded(
              child: Text(
                weekday,
                textAlign: TextAlign.center,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime selectedDay;
  final Map<DateTime, List<UpcomingEvent>> eventsByDate;
  final ValueChanged<DateTime> onDaySelected;

  const _MonthGrid({
    required this.visibleMonth,
    required this.selectedDay,
    required this.eventsByDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = _calendarDaysForMonth(visibleMonth);

    return GridView.builder(
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: AppConstants.spacingSM,
        crossAxisSpacing: AppConstants.spacingSM,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        final dateKey = DateTime(day.year, day.month, day.day);
        final events = eventsByDate[dateKey] ?? const [];

        return _CalendarDayTile(
          day: day,
          events: events,
          isVisibleMonth: day.month == visibleMonth.month,
          isSelected: _isSameDay(day, selectedDay),
          isToday: _isSameDay(day, DateTime.now()),
          onTap: () => onDaySelected(dateKey),
        );
      },
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  final DateTime day;
  final List<UpcomingEvent> events;
  final bool isVisibleMonth;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _CalendarDayTile({
    required this.day,
    required this.events,
    required this.isVisibleMonth,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? context.colorScheme.primary
        : isToday
        ? context.colorScheme.secondary
        : context.colorScheme.outlineVariant;

    return Material(
      color: isSelected
          ? context.colorScheme.primary.withValues(alpha: 0.18)
          : context.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: context.radiusSM,
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: context.paddingSM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    day.day.toString(),
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isVisibleMonth
                          ? context.colorScheme.secondary
                          : context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (events.isNotEmpty)
                    Badge.count(
                      count: events.length,
                      backgroundColor: context.colorScheme.primary,
                      textColor: context.colorScheme.onPrimary,
                    ),
                ],
              ),
              context.gapXS,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: events
                      .take(2)
                      .map((event) {
                        final color = upcomingEventCategoryColor(
                          context,
                          event.category,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppConstants.spacingXS,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              context.gapXS,
                              Expanded(
                                child: Text(
                                  event.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedDayPanel extends StatelessWidget {
  final DateTime selectedDay;
  final List<UpcomingEvent> events;
  final VoidCallback onAddEvent;
  final ValueChanged<UpcomingEvent> onEditEvent;
  final ValueChanged<UpcomingEvent> onDeleteEvent;

  const _SelectedDayPanel({
    required this.selectedDay,
    required this.events,
    required this.onAddEvent,
    required this.onEditEvent,
    required this.onDeleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatEventDateWithWeekday(selectedDay),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton.filled(
                tooltip: 'Add event',
                onPressed: onAddEvent,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          context.gapXS,
          Row(
            children: [
              Expanded(
                child: Text(
                  '${events.length} event${events.length == 1 ? '' : 's'}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (events.any((event) => !event.canEdit))
                Tooltip(
                  message: 'Synced events are read-only',
                  child: Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          context.gapMD,
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'No events',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: events.length,
                    separatorBuilder: (_, _) => context.gapSM,
                    itemBuilder: (context, index) {
                      return _AgendaEventTile(
                        event: events[index],
                        onEdit: onEditEvent,
                        onDelete: onDeleteEvent,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AgendaEventTile extends StatelessWidget {
  final UpcomingEvent event;
  final ValueChanged<UpcomingEvent> onEdit;
  final ValueChanged<UpcomingEvent> onDelete;

  const _AgendaEventTile({
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = upcomingEventCategoryColor(context, event.category);

    return GlassContainer(
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.16),
          foregroundColor: color,
          child: Icon(upcomingEventCategoryIcon(event.category), size: 20),
        ),
        title: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: event.canEdit
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') onEdit(event);
                  if (value == 'delete') onDelete(event);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              )
            : const Tooltip(
                message: 'Synced event',
                child: Icon(Icons.lock_outline, size: 18),
              ),
      ),
    );
  }
}

Future<void> _showEventDialog(
  BuildContext context,
  WidgetRef ref, {
  UpcomingEvent? event,
  required DateTime initialDate,
}) async {
  final isEditing = event != null;
  final titleController = TextEditingController(text: event?.title ?? '');
  final descriptionController = TextEditingController(
    text: event?.description ?? '',
  );
  var selectedDate = event?.startsAt ?? initialDate;
  var startTime = TimeOfDay.fromDateTime(event?.startsAt ?? initialDate);
  var hasEndTime = event?.endsAt != null;
  var endTime = TimeOfDay.fromDateTime(
    event?.endsAt ??
        (event?.startsAt ?? initialDate).add(const Duration(hours: 1)),
  );
  var category = event?.category ?? UpcomingEventCategory.personal;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          Future<void> pickDate() async {
            final picked = await showDatePicker(
              context: dialogContext,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (picked == null) return;
            setDialogState(() => selectedDate = picked);
          }

          Future<void> pickStartTime() async {
            final picked = await showTimePicker(
              context: dialogContext,
              initialTime: startTime,
            );
            if (picked == null) return;
            setDialogState(() => startTime = picked);
          }

          Future<void> pickEndTime() async {
            final picked = await showTimePicker(
              context: dialogContext,
              initialTime: endTime,
            );
            if (picked == null) return;
            setDialogState(() => endTime = picked);
          }

          return AlertDialog(
            title: Text(isEditing ? 'Edit event' : 'Add event'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    context.gapMD,
                    TextField(
                      controller: descriptionController,
                      minLines: 2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    context.gapMD,
                    DropdownButtonFormField<UpcomingEventCategory>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: _editableCategories.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Row(
                            children: [
                              Icon(upcomingEventCategoryIcon(value), size: 18),
                              context.gapSM,
                              Text(upcomingEventCategoryLabel(value)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => category = value);
                      },
                    ),
                    context.gapMD,
                    _DialogActionButton(
                      icon: Icons.calendar_today_outlined,
                      label: formatEventDate(selectedDate),
                      onPressed: pickDate,
                    ),
                    context.gapSM,
                    Row(
                      children: [
                        _DialogActionButton(
                          icon: Icons.schedule,
                          label: startTime.format(context),
                          onPressed: pickStartTime,
                        ).expanded(),
                        context.gapSM,
                        _DialogActionButton(
                          icon: Icons.flag_outlined,
                          label: hasEndTime
                              ? endTime.format(context)
                              : 'No end',
                          onPressed: hasEndTime ? pickEndTime : null,
                        ).expanded(),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('End time'),
                      value: hasEndTime,
                      onChanged: (value) {
                        setDialogState(() => hasEndTime = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;

                  final startsAt = _dateWithTime(selectedDate, startTime);
                  final endsAt = hasEndTime
                      ? _dateWithTime(selectedDate, endTime)
                      : null;
                  if (endsAt != null && !endsAt.isAfter(startsAt)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('End time must be after start time'),
                      ),
                    );
                    return;
                  }

                  final savedEvent = UpcomingEvent(
                    id: event?.id ?? nextUpcomingEventId(),
                    title: title,
                    startsAt: startsAt,
                    endsAt: endsAt,
                    description: _optionalText(descriptionController.text),
                    category: category,
                    createdAt: event?.createdAt ?? DateTime.now(),
                  );

                  final controller = ref.read(upcomingEventControllerProvider);
                  if (isEditing) {
                    await controller.updateEvent(savedEvent);
                  } else {
                    await controller.createEvent(savedEvent);
                  }
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: Text(isEditing ? 'Save' : 'Create'),
              ),
            ],
          );
        },
      );
    },
  );
}

class _DialogActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _DialogActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

Future<void> _confirmDeleteEvent(
  BuildContext context,
  WidgetRef ref,
  UpcomingEvent event,
) async {
  if (!event.canEdit) return;
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete event'),
        content: Text('Delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (shouldDelete ?? false) {
    await ref.read(upcomingEventControllerProvider).deleteEvent(event);
  }
}

List<DateTime> _calendarDaysForMonth(DateTime month) {
  final firstDay = DateTime(month.year, month.month);
  final gridStart = firstDay.subtract(Duration(days: firstDay.weekday - 1));

  return List<DateTime>.generate(42, (index) {
    return gridStart.add(Duration(days: index));
  });
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime _dateWithTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

String? _optionalText(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

const _editableCategories = <UpcomingEventCategory>[
  UpcomingEventCategory.personal,
  UpcomingEventCategory.birthday,
  UpcomingEventCategory.appointment,
  UpcomingEventCategory.other,
];
