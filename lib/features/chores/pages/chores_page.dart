import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/chores/application/chore_providers.dart';
import 'package:habi/features/chores/data/chore_store.dart';
import 'package:habi/shared/widgets/glass_container.dart';

enum _ChoreView { due, backlog, recurring, areas }

enum _StatusFilter { all, open, completed, overdue }

enum _SortOption { dueDate, area, createdDate }

class ChoresPage extends ConsumerStatefulWidget {
  const ChoresPage({super.key});

  @override
  ConsumerState<ChoresPage> createState() => _ChoresPageState();
}

class _ChoresPageState extends ConsumerState<ChoresPage> {
  _ChoreView _view = _ChoreView.due;
  ChoreType? _typeFilter;
  String? _areaFilter;
  String? _assignedToFilter;
  _StatusFilter _statusFilter = _StatusFilter.open;
  _SortOption _sortOption = _SortOption.dueDate;

  @override
  Widget build(BuildContext context) {
    final choresState = ref.watch(choresProvider);

    return choresState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassContainer(
        isElevated: true,
        child: Center(child: Text('Could not load chores: $error')),
      ),
      data: (chores) {
        final filtered = _applyFilters(_choresForView(chores));
        final sorted = _sortChores(filtered);

        return GlassContainer(
          isElevated: true,
          child: Padding(
            padding: context.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  chores: chores,
                  onAddPressed: () => _showChoreDialog(context, ref),
                ),
                context.gapLG,
                _ViewTabs(
                  selectedView: _view,
                  onViewChanged: (view) {
                    setState(() {
                      _view = view;
                      _typeFilter = null;
                      if (view == _ChoreView.backlog) {
                        _sortOption = _SortOption.createdDate;
                      } else if (view == _ChoreView.areas) {
                        _sortOption = _SortOption.area;
                      } else {
                        _sortOption = _SortOption.dueDate;
                      }
                    });
                  },
                ),
                context.gapMD,
                _FilterBar(
                  typeFilter: _typeFilter,
                  areaFilter: _areaFilter,
                  assignedToFilter: _assignedToFilter,
                  statusFilter: _statusFilter,
                  sortOption: _sortOption,
                  onTypeChanged: (value) => setState(() => _typeFilter = value),
                  onAreaChanged: (value) => setState(() => _areaFilter = value),
                  onAssignedChanged: (value) {
                    setState(() => _assignedToFilter = value);
                  },
                  onStatusChanged: (value) {
                    setState(() => _statusFilter = value);
                  },
                  onSortChanged: (value) => setState(() => _sortOption = value),
                ),
                context.gapMD,
                Expanded(
                  child: _view == _ChoreView.areas
                      ? _AreasList(chores: sorted)
                      : _ChoreList(chores: sorted, view: _view),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Chore> _choresForView(List<Chore> chores) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comingSoon = today.add(const Duration(days: 14));

    switch (_view) {
      case _ChoreView.due:
        return chores
            .where((chore) {
              final due = chore.nextDue;
              if (due == null || chore.type == ChoreType.unscheduled) {
                return false;
              }
              final dueDay = DateTime(due.year, due.month, due.day);
              return dueDay.isBefore(comingSoon) ||
                  dueDay.isAtSameMomentAs(comingSoon);
            })
            .toList(growable: false);
      case _ChoreView.backlog:
        return chores
            .where((chore) => chore.type == ChoreType.unscheduled)
            .toList(growable: false);
      case _ChoreView.recurring:
        return chores
            .where((chore) => chore.type == ChoreType.recurring)
            .toList(growable: false);
      case _ChoreView.areas:
        return chores;
    }
  }

  List<Chore> _applyFilters(List<Chore> chores) {
    final now = DateTime.now();
    return chores
        .where((chore) {
          if (_typeFilter != null && chore.type != _typeFilter) return false;
          if (_areaFilter != null && chore.area != _areaFilter) return false;
          if (_assignedToFilter != null &&
              chore.assignedTo != _assignedToFilter) {
            return false;
          }
          switch (_statusFilter) {
            case _StatusFilter.all:
              return true;
            case _StatusFilter.open:
              return !chore.isDone;
            case _StatusFilter.completed:
              return chore.isDone;
            case _StatusFilter.overdue:
              return chore.isOverdue(now);
          }
        })
        .toList(growable: false);
  }

  List<Chore> _sortChores(List<Chore> chores) {
    final sorted = List<Chore>.from(chores);
    sorted.sort((a, b) {
      switch (_sortOption) {
        case _SortOption.dueDate:
          return _compareNullableDates(a.nextDue, b.nextDue);
        case _SortOption.area:
          final area = a.area.compareTo(b.area);
          return area == 0 ? _compareNullableDates(a.nextDue, b.nextDue) : area;
        case _SortOption.createdDate:
          return b.createdAt.compareTo(a.createdAt);
      }
    });
    return sorted;
  }
}

class _Header extends StatelessWidget {
  final List<Chore> chores;
  final VoidCallback onAddPressed;

  const _Header({required this.chores, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comingSoon = today.add(const Duration(days: 14));
    final dueCount = chores.where((chore) {
      final due = chore.nextDue;
      if (due == null || chore.type == ChoreType.unscheduled || chore.isDone) {
        return false;
      }
      final dueDay = DateTime(due.year, due.month, due.day);
      return dueDay.isBefore(comingSoon) || dueDay.isAtSameMomentAs(comingSoon);
    }).length;
    final backlogCount = chores
        .where((chore) => chore.type == ChoreType.unscheduled && !chore.isDone)
        .length;
    final recurringCount = chores
        .where((chore) => chore.type == ChoreType.recurring)
        .length;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chores',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              context.gapXS,
              Text(
                '$dueCount due - $backlogCount backlog - $recurringCount recurring',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add chore'),
        ),
      ],
    );
  }
}

class _ViewTabs extends StatelessWidget {
  final _ChoreView selectedView;
  final ValueChanged<_ChoreView> onViewChanged;

  const _ViewTabs({required this.selectedView, required this.onViewChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppConstants.spacingSM,
      children: _ChoreView.values.map((view) {
        return _SegmentButton(
          label: _viewLabel(view),
          isSelected: selectedView == view,
          onPressed: () => onViewChanged(view),
        ).expanded();
      }).toList(),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final ChoreType? typeFilter;
  final String? areaFilter;
  final String? assignedToFilter;
  final _StatusFilter statusFilter;
  final _SortOption sortOption;
  final ValueChanged<ChoreType?> onTypeChanged;
  final ValueChanged<String?> onAreaChanged;
  final ValueChanged<String?> onAssignedChanged;
  final ValueChanged<_StatusFilter> onStatusChanged;
  final ValueChanged<_SortOption> onSortChanged;

  const _FilterBar({
    required this.typeFilter,
    required this.areaFilter,
    required this.assignedToFilter,
    required this.statusFilter,
    required this.sortOption,
    required this.onTypeChanged,
    required this.onAreaChanged,
    required this.onAssignedChanged,
    required this.onStatusChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.spacingSM,
      runSpacing: AppConstants.spacingSM,
      children: [
        _FilterMenu<ChoreType?>(
          label: 'Type',
          value: typeFilter,
          options: const [null, ...ChoreType.values],
          optionLabel: (value) =>
              value == null ? 'All types' : _typeLabel(value),
          onChanged: onTypeChanged,
        ),
        _FilterMenu<String?>(
          label: 'Area',
          value: areaFilter,
          options: const [null, ...choreAreas],
          optionLabel: (value) => value ?? 'All areas',
          onChanged: onAreaChanged,
        ),
        _FilterMenu<String?>(
          label: 'Person',
          value: assignedToFilter,
          options: const [null, ...choreOwners],
          optionLabel: (value) => value ?? 'Anyone',
          onChanged: onAssignedChanged,
        ),
        _FilterMenu<_StatusFilter>(
          label: 'Status',
          value: statusFilter,
          options: _StatusFilter.values,
          optionLabel: _statusLabel,
          onChanged: onStatusChanged,
        ),
        _FilterMenu<_SortOption>(
          label: 'Sort',
          value: sortOption,
          options: _SortOption.values,
          optionLabel: _sortLabel,
          onChanged: onSortChanged,
        ),
      ],
    );
  }
}

class _FilterMenu<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> options;
  final String Function(T value) optionLabel;
  final ValueChanged<T> onChanged;

  const _FilterMenu({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: options.map((option) {
          return DropdownMenuItem<T>(
            value: option,
            child: Text(optionLabel(option), overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null && !options.contains(null)) return;
          onChanged(value as T);
        },
      ),
    );
  }
}

class _ChoreList extends StatelessWidget {
  final List<Chore> chores;
  final _ChoreView view;

  const _ChoreList({required this.chores, required this.view});

  @override
  Widget build(BuildContext context) {
    if (chores.isEmpty) {
      return _EmptyState(view: view);
    }

    return ListView.separated(
      itemCount: chores.length,
      separatorBuilder: (_, _) => context.gapSM,
      itemBuilder: (context, index) => _ChoreTile(chore: chores[index]),
    );
  }
}

class _AreasList extends StatelessWidget {
  final List<Chore> chores;

  const _AreasList({required this.chores});

  @override
  Widget build(BuildContext context) {
    if (chores.isEmpty) return const _EmptyState(view: _ChoreView.areas);

    final grouped = <String, List<Chore>>{};
    for (final chore in chores) {
      grouped.putIfAbsent(chore.area, () => []).add(chore);
    }
    final areas = grouped.keys.toList()..sort();

    return ListView.separated(
      itemCount: areas.length,
      separatorBuilder: (_, _) => context.gapMD,
      itemBuilder: (context, index) {
        final area = areas[index];
        final areaChores = grouped[area]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  area,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                context.gapSM,
                Text(
                  areaChores.length.toString(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            context.gapSM,
            ...areaChores.map((chore) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingSM),
                child: _ChoreTile(chore: chore),
              );
            }),
          ],
        );
      },
    );
  }
}

class _ChoreTile extends ConsumerWidget {
  final Chore chore;

  const _ChoreTile({required this.chore});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecurring = chore.type == ChoreType.recurring;
    final isTodo = chore.type != ChoreType.recurring;
    final overdue = chore.isOverdue(DateTime.now());

    return GlassContainer(
      child: Padding(
        padding: context.paddingMD,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: overdue
                    ? context.colorScheme.errorContainer
                    : chore.type == ChoreType.unscheduled
                    ? context.colorScheme.surfaceContainerHigh
                    : context.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: context.radiusSM,
              ),
              child: Icon(switch (chore.type) {
                ChoreType.recurring => Icons.event_repeat,
                ChoreType.scheduled => Icons.task_alt,
                ChoreType.unscheduled => Icons.inventory_2,
              }, color: context.colorScheme.secondary),
            ),
            context.gapMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chore.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            decoration: chore.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      _TypePill(chore: chore),
                    ],
                  ),
                  context.gapSM,
                  Wrap(
                    spacing: AppConstants.spacingSM,
                    runSpacing: AppConstants.spacingXS,
                    children: [
                      _ChoreMeta(icon: Icons.place, label: chore.area),
                      _ChoreMeta(icon: Icons.person, label: chore.assignedTo),
                      _ChoreMeta(
                        icon: Icons.calendar_today,
                        label: _formatDueDate(chore.nextDue),
                        isEmphasized: overdue,
                      ),
                      if (isRecurring)
                        _ChoreMeta(
                          icon: Icons.schedule,
                          label: chore.recurrence ?? 'Recurring',
                        ),
                      if (isRecurring)
                        _ChoreMeta(
                          icon:
                              chore.recurrenceBehavior ==
                                  RecurrenceBehavior.fixed
                              ? Icons.lock_clock
                              : Icons.update,
                          label:
                              chore.recurrenceBehavior ==
                                  RecurrenceBehavior.fixed
                              ? 'Fixed'
                              : 'Flexible',
                        ),
                      _ChoreMeta(
                        icon: chore.isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        label: chore.isDone ? 'Completed' : 'Open',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            context.gapSM,
            if (isTodo)
              Checkbox(
                value: chore.isDone,
                onChanged: (_) => _toggleTodoDone(ref, chore),
              )
            else
              IconButton(
                tooltip: 'Complete and schedule next',
                onPressed: chore.canComplete
                    ? () =>
                          ref.read(choreControllerProvider).completeChore(chore)
                    : null,
                icon: const Icon(Icons.check_circle_outline),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _showChoreDialog(context, ref, chore: chore);
                  return;
                }
                if (value == 'delete') {
                  _confirmDelete(context, ref, chore);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final Chore chore;

  const _TypePill({required this.chore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSM,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: switch (chore.type) {
          ChoreType.recurring => context.colorScheme.primary.withValues(
            alpha: 0.2,
          ),
          ChoreType.scheduled => context.colorScheme.tertiaryContainer,
          ChoreType.unscheduled => context.colorScheme.secondaryContainer,
        },
        borderRadius: context.radiusXS,
      ),
      child: Text(
        chore.typeLabel,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ChoreMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEmphasized;

  const _ChoreMeta({
    required this.icon,
    required this.label,
    this.isEmphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isEmphasized
        ? context.colorScheme.error
        : context.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: isEmphasized ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerHigh,
          foregroundColor: isSelected
              ? context.colorScheme.onPrimary
              : context.colorScheme.onSurfaceVariant,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: context.radiusSM),
        ),
        child: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final _ChoreView view;

  const _EmptyState({required this.view});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        switch (view) {
          _ChoreView.due => 'No due chores match these filters',
          _ChoreView.backlog => 'No backlog todos match these filters',
          _ChoreView.recurring => 'No recurring chores match these filters',
          _ChoreView.areas => 'No chores match these filters',
        },
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

Future<void> _showChoreDialog(
  BuildContext context,
  WidgetRef ref, {
  Chore? chore,
}) async {
  final isEditing = chore != null;
  final titleController = TextEditingController(text: chore?.title ?? '');
  final recurrenceController = TextEditingController(
    text: chore?.recurrence ?? '',
  );
  var type = chore?.type ?? ChoreType.recurring;
  var recurrenceBehavior =
      chore?.recurrenceBehavior ?? RecurrenceBehavior.fixed;
  var area = _optionOrDefault(chore?.area, choreAreas, defaultChoreArea);
  var assignedTo = _optionOrDefault(
    chore?.assignedTo,
    choreOwners,
    unassignedChoreOwner,
  );
  var isActive = chore?.isActive ?? true;
  var isDone = chore?.isDone ?? false;
  var dueDate = chore?.nextDue ?? DateTime.now();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEditing ? 'Edit chore' : 'Add chore'),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    context.gapMD,
                    Row(
                      children: [
                        _DialogTypeButton(
                          label: 'Recurring',
                          isSelected: type == ChoreType.recurring,
                          onPressed: () {
                            setDialogState(() => type = ChoreType.recurring);
                          },
                        ).expanded(),
                        context.gapSM,
                        _DialogTypeButton(
                          label: 'Scheduled',
                          isSelected: type == ChoreType.scheduled,
                          onPressed: () {
                            setDialogState(() => type = ChoreType.scheduled);
                          },
                        ).expanded(),
                        context.gapSM,
                        _DialogTypeButton(
                          label: 'Backlog',
                          isSelected: type == ChoreType.unscheduled,
                          onPressed: () {
                            setDialogState(() => type = ChoreType.unscheduled);
                          },
                        ).expanded(),
                      ],
                    ),
                    context.gapMD,
                    DropdownButtonFormField<String>(
                      initialValue: area,
                      decoration: const InputDecoration(labelText: 'Area'),
                      items: choreAreas.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => area = value);
                      },
                    ),
                    context.gapMD,
                    DropdownButtonFormField<String>(
                      initialValue: assignedTo,
                      decoration: const InputDecoration(
                        labelText: 'Assigned to',
                      ),
                      items: choreOwners.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => assignedTo = value);
                      },
                    ),
                    if (type == ChoreType.recurring) ...[
                      context.gapMD,
                      TextField(
                        controller: recurrenceController,
                        decoration: const InputDecoration(
                          labelText: 'Recurrence',
                          hintText: 'Weekly, Every 3 days, Monthly...',
                        ),
                      ),
                      context.gapMD,
                      Row(
                        children: [
                          _DialogTypeButton(
                            label: 'Fixed',
                            isSelected:
                                recurrenceBehavior == RecurrenceBehavior.fixed,
                            onPressed: () {
                              setDialogState(
                                () => recurrenceBehavior =
                                    RecurrenceBehavior.fixed,
                              );
                            },
                          ).expanded(),
                          context.gapSM,
                          _DialogTypeButton(
                            label: 'Flexible',
                            isSelected:
                                recurrenceBehavior ==
                                RecurrenceBehavior.flexible,
                            onPressed: () {
                              setDialogState(
                                () => recurrenceBehavior =
                                    RecurrenceBehavior.flexible,
                              );
                            },
                          ).expanded(),
                        ],
                      ),
                    ],
                    if (type != ChoreType.unscheduled) ...[
                      context.gapMD,
                      Row(
                        children: [
                          Expanded(
                            child: Text('Due ${_formatDueDate(dueDate)}'),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: dueDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                              );
                              if (selectedDate == null) return;
                              setDialogState(() => dueDate = selectedDate);
                            },
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: const Text('Pick date'),
                          ),
                        ],
                      ),
                    ],
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() => isActive = value);
                      },
                    ),
                    if (type != ChoreType.recurring)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Completed'),
                        value: isDone,
                        onChanged: (value) {
                          setDialogState(() => isDone = value ?? false);
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
                onPressed: () {
                  final title = titleController.text.trim();
                  final recurrence = recurrenceController.text.trim();

                  if (title.isEmpty) return;

                  final savedChore = Chore(
                    id: chore?.id ?? nextChoreId(),
                    title: title,
                    area: area,
                    type: type,
                    recurrence:
                        type == ChoreType.recurring && recurrence.isNotEmpty
                        ? recurrence
                        : null,
                    recurrenceBehavior: recurrenceBehavior,
                    assignedTo: assignedTo,
                    nextDue: type == ChoreType.unscheduled ? null : dueDate,
                    isActive: isActive,
                    isDone: type == ChoreType.recurring ? false : isDone,
                    createdAt: chore?.createdAt ?? DateTime.now(),
                  );

                  if (isEditing) {
                    ref.read(choreControllerProvider).updateChore(savedChore);
                  } else {
                    ref.read(choreControllerProvider).createChore(savedChore);
                  }
                  Navigator.of(dialogContext).pop();
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

class _DialogTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _DialogTypeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _SegmentButton(
      label: label,
      isSelected: isSelected,
      onPressed: onPressed,
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  Chore chore,
) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete chore'),
        content: Text('Delete "${chore.title}"?'),
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
    await ref.read(choreControllerProvider).deleteChore(chore.id);
  }
}

void _toggleTodoDone(WidgetRef ref, Chore chore) {
  if (chore.isDone) {
    ref.read(choreControllerProvider).reopenChore(chore);
    return;
  }

  ref.read(choreControllerProvider).completeChore(chore);
}

int _compareNullableDates(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}

String _formatDueDate(DateTime? date) {
  if (date == null) return 'No due date';
  return '${date.day}/${date.month}/${date.year}';
}

String _viewLabel(_ChoreView view) {
  switch (view) {
    case _ChoreView.due:
      return 'Due';
    case _ChoreView.backlog:
      return 'Backlog';
    case _ChoreView.recurring:
      return 'Recurring';
    case _ChoreView.areas:
      return 'Areas';
  }
}

String _typeLabel(ChoreType type) {
  switch (type) {
    case ChoreType.recurring:
      return 'Recurring';
    case ChoreType.scheduled:
      return 'Scheduled';
    case ChoreType.unscheduled:
      return 'Backlog';
  }
}

String _statusLabel(_StatusFilter status) {
  switch (status) {
    case _StatusFilter.all:
      return 'All status';
    case _StatusFilter.open:
      return 'Open';
    case _StatusFilter.completed:
      return 'Completed';
    case _StatusFilter.overdue:
      return 'Overdue';
  }
}

String _sortLabel(_SortOption sort) {
  switch (sort) {
    case _SortOption.dueDate:
      return 'Due date';
    case _SortOption.area:
      return 'Area';
    case _SortOption.createdDate:
      return 'Created';
  }
}

String _optionOrDefault(
  String? value,
  List<String> allowedValues,
  String fallback,
) {
  if (value == null) return fallback;
  for (final allowedValue in allowedValues) {
    if (allowedValue.toLowerCase() == value.toLowerCase()) {
      return allowedValue;
    }
  }
  return fallback;
}
