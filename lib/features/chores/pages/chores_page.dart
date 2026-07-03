import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/chores/application/chore_queries.dart';
import 'package:habi/features/chores/application/chore_providers.dart';
import 'package:habi/features/chores/data/chore_store.dart';
import 'package:habi/features/chores/presentation/chore_visuals.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class ChoresPage extends ConsumerStatefulWidget {
  const ChoresPage({super.key});

  @override
  ConsumerState<ChoresPage> createState() => _ChoresPageState();
}

class _ChoresPageState extends ConsumerState<ChoresPage> {
  ChoreView _view = ChoreView.due;

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
        final visibleChores = choresForView(chores, _view);
        final summary = summarizeChores(chores);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              isElevated: true,
              padding: context.paddingLG,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    summary: summary,
                    onAddPressed: () => _showChoreDialog(context, ref),
                  ),
                  context.gapLG,
                  _ViewTabs(
                    selectedView: _view,
                    onViewChanged: (view) => setState(() => _view = view),
                  ),
                ],
              ),
            ),
            context.gapLG,
            Expanded(
              child: _view == ChoreView.areas
                  ? _AreasList(chores: visibleChores)
                  : _ChoreList(chores: visibleChores, view: _view),
            ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final ChoreSummary summary;
  final VoidCallback onAddPressed;

  const _Header({required this.summary, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chores',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              context.gapXS,
              Text(
                '${summary.dueCount} due - ${summary.todoCount} todos - ${summary.recurringCount} recurring',
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
  final ChoreView selectedView;
  final ValueChanged<ChoreView> onViewChanged;

  const _ViewTabs({required this.selectedView, required this.onViewChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ChoreView>(
        showSelectedIcon: false,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return context.colorScheme.secondary;
            }
            return context.colorScheme.surfaceContainerLowest.withValues(
              alpha: 0.46,
            );
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return context.colorScheme.onSecondary;
            }
            return context.colorScheme.onSurfaceVariant;
          }),
        ),
        segments: ChoreView.values.map((view) {
          return ButtonSegment<ChoreView>(
            value: view,
            label: Text(_viewLabel(view), overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        selected: {selectedView},
        onSelectionChanged: (selection) {
          onViewChanged(selection.first);
        },
      ),
    );
  }
}

class _ChoreList extends StatelessWidget {
  final List<Chore> chores;
  final ChoreView view;

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
    if (chores.isEmpty) return const _EmptyState(view: ChoreView.areas);

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
      padding: context.paddingMD,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  (overdue
                          ? context.colorScheme.error
                          : chore.type == ChoreType.todo
                          ? context.colorScheme.primary
                          : recurringChoreColor(context, chore.colorKey))
                      .withValues(alpha: 0.13),
              borderRadius: context.radiusLG,
              border: Border.all(
                color:
                    (overdue
                            ? context.colorScheme.error
                            : chore.type == ChoreType.todo
                            ? context.colorScheme.primary
                            : recurringChoreColor(context, chore.colorKey))
                        .withValues(alpha: 0.16),
              ),
            ),
            child: Icon(
              switch (chore.type) {
                ChoreType.recurring => recurringChoreIcon(chore.iconKey),
                ChoreType.todo =>
                  chore.nextDue == null ? Icons.inventory_2 : Icons.task_alt,
              },
              color: overdue
                  ? context.colorScheme.error
                  : context.colorScheme.onSurface,
            ),
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
                          fontWeight: FontWeight.w800,
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
                      label: _dateMetaLabel(chore),
                      isEmphasized: overdue,
                    ),
                    if (isRecurring)
                      _ChoreMeta(
                        icon: Icons.schedule,
                        label: chore.scheduleLabel,
                      ),
                    if (isRecurring)
                      _ChoreMeta(
                        icon:
                            chore.recurrenceBehavior == RecurrenceBehavior.fixed
                            ? Icons.lock_clock
                            : Icons.update,
                        label:
                            chore.recurrenceBehavior == RecurrenceBehavior.fixed
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
                  ? () => ref.read(choreControllerProvider).completeChore(chore)
                  : null,
              icon: const Icon(Icons.check_circle_outline_rounded),
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
    );
  }
}

class _TypePill extends StatelessWidget {
  final Chore chore;

  const _TypePill({required this.chore});

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: chore.typeLabel,
      color: switch (chore.type) {
        ChoreType.recurring => recurringChoreColor(context, chore.colorKey),
        ChoreType.todo =>
          chore.nextDue == null
              ? context.colorScheme.onSurfaceVariant
              : context.colorScheme.tertiary,
      },
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

    return StatusChip(
      label: label,
      icon: icon,
      color: color,
      emphasized: isEmphasized,
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
              ? context.colorScheme.secondary
              : context.colorScheme.surfaceContainerLowest.withValues(
                  alpha: 0.46,
                ),
          foregroundColor: isSelected
              ? context.colorScheme.onSecondary
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
  final ChoreView view;

  const _EmptyState({required this.view});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        switch (view) {
          ChoreView.due => 'No due chores match these filters',
          ChoreView.todos => 'No todos match these filters',
          ChoreView.recurring => 'No recurring chores match these filters',
          ChoreView.areas => 'No chores match these filters',
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
  var type = chore?.type ?? ChoreType.todo;
  var recurrenceBehavior =
      chore?.recurrenceBehavior ?? RecurrenceBehavior.fixed;
  var recurrenceRule = chore?.recurrenceRule ?? defaultRecurrenceRule;
  var area = _optionOrDefault(chore?.area, choreAreas, defaultChoreArea);
  var assignedTo = _optionOrDefault(
    chore?.assignedTo,
    choreOwners,
    unassignedChoreOwner,
  );
  var iconKey = _optionOrDefault(
    chore?.iconKey,
    recurringChoreIconKeys,
    defaultRecurringChoreIconKey,
  );
  var colorKey = _optionOrDefault(
    chore?.colorKey,
    recurringChoreColorKeys,
    defaultRecurringChoreColorKey,
  );
  var dueDate = chore?.nextDue ?? DateTime.now();
  var hasDueDate = chore?.nextDue != null || type == ChoreType.recurring;

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
                          label: 'Todo',
                          isSelected: type == ChoreType.todo,
                          onPressed: () {
                            setDialogState(() => type = ChoreType.todo);
                          },
                        ).expanded(),
                        context.gapSM,
                        _DialogTypeButton(
                          label: 'Recurring',
                          isSelected: type == ChoreType.recurring,
                          onPressed: () {
                            setDialogState(() {
                              type = ChoreType.recurring;
                              hasDueDate = true;
                            });
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
                      _RecurringVisualEditor(
                        iconKey: iconKey,
                        colorKey: colorKey,
                        onIconChanged: (value) {
                          setDialogState(() => iconKey = value);
                        },
                        onColorChanged: (value) {
                          setDialogState(() => colorKey = value);
                        },
                      ),
                      context.gapMD,
                      _RecurrenceRuleEditor(
                        rule: recurrenceRule,
                        onChanged: (value) {
                          setDialogState(() => recurrenceRule = value);
                        },
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
                    if (type == ChoreType.recurring || hasDueDate) ...[
                      context.gapMD,
                      _DateButton(
                        label: type == ChoreType.recurring
                            ? 'Next due ${_formatDueDate(dueDate)}'
                            : 'Due ${_formatDueDate(dueDate)}',
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
                        trailing: type == ChoreType.todo
                            ? IconButton(
                                tooltip: 'Remove due date',
                                onPressed: () {
                                  setDialogState(() => hasDueDate = false);
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                    ] else ...[
                      context.gapMD,
                      _DateButton(
                        label: 'Add due date',
                        onPressed: () {
                          setDialogState(() => hasDueDate = true);
                        },
                      ),
                    ],
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

                  if (title.isEmpty) return;
                  final savedRecurrenceRule = recurrenceRule.normalized();

                  final savedChore = Chore(
                    id: chore?.id ?? nextChoreId(),
                    title: title,
                    area: area,
                    type: type,
                    recurrence: type == ChoreType.recurring
                        ? savedRecurrenceRule.label
                        : null,
                    recurrenceRule: type == ChoreType.recurring
                        ? savedRecurrenceRule
                        : null,
                    recurrenceBehavior: recurrenceBehavior,
                    assignedTo: assignedTo,
                    nextDue: type == ChoreType.todo && !hasDueDate
                        ? null
                        : dueDate,
                    isActive: chore?.isActive ?? true,
                    isDone: type == ChoreType.recurring
                        ? false
                        : chore?.isDone ?? false,
                    createdAt: chore?.createdAt ?? DateTime.now(),
                    iconKey: type == ChoreType.recurring
                        ? iconKey
                        : defaultRecurringChoreIconKey,
                    colorKey: type == ChoreType.recurring
                        ? colorKey
                        : defaultRecurringChoreColorKey,
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

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? trailing;

  const _DateButton({
    required this.label,
    required this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    if (trailing == null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(label),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(label),
          ),
        ),
        context.gapSM,
        trailing!,
      ],
    );
  }
}

class _RecurringVisualEditor extends StatelessWidget {
  final String iconKey;
  final String colorKey;
  final ValueChanged<String> onIconChanged;
  final ValueChanged<String> onColorChanged;

  const _RecurringVisualEditor({
    required this.iconKey,
    required this.colorKey,
    required this.onIconChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButtonFormField<String>(
          initialValue: iconKey,
          decoration: const InputDecoration(labelText: 'Icon'),
          items: recurringChoreIconKeys.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Center(child: Icon(recurringChoreIcon(value), size: 20)),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            onIconChanged(value);
          },
        ).expanded(),
        context.gapSM,
        DropdownButtonFormField<String>(
          initialValue: colorKey,
          decoration: const InputDecoration(labelText: 'Color'),
          items: recurringChoreColorKeys.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: recurringChoreColor(context, value),
                      borderRadius: context.radiusXS,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  Text(recurringChoreColorLabel(value)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            onColorChanged(value);
          },
        ).expanded(),
      ],
    );
  }
}

class _RecurrenceRuleEditor extends StatelessWidget {
  final RecurrenceRule rule;
  final ValueChanged<RecurrenceRule> onChanged;

  const _RecurrenceRuleEditor({required this.rule, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final normalized = rule.normalized();

    return Column(
      children: [
        Row(
          children: [
            DropdownButtonFormField<RecurrenceFrequency>(
              initialValue: normalized.frequency,
              decoration: const InputDecoration(labelText: 'Repeats'),
              items: RecurrenceFrequency.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(_frequencyLabel(value)),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                onChanged(_ruleForFrequency(value, normalized));
              },
            ).expanded(),
            context.gapSM,
            DropdownButtonFormField<int>(
              initialValue: normalized.interval,
              decoration: const InputDecoration(labelText: 'Every'),
              items: _numberOptions(1, 12).map((value) {
                return DropdownMenuItem(value: value, child: Text('$value'));
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                onChanged(normalized.copyWith(interval: value));
              },
            ).expanded(),
          ],
        ),
        if (normalized.frequency == RecurrenceFrequency.weekly) ...[
          context.gapMD,
          DropdownButtonFormField<int>(
            initialValue: normalized.weekday ?? DateTime.monday,
            decoration: const InputDecoration(labelText: 'Weekday'),
            items: _weekdays.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(weekdayLabel(value)),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              onChanged(normalized.copyWith(weekday: value));
            },
          ),
        ],
        if (normalized.frequency == RecurrenceFrequency.monthly) ...[
          context.gapMD,
          DropdownButtonFormField<MonthlyRecurrenceKind>(
            initialValue:
                normalized.monthlyKind ?? MonthlyRecurrenceKind.dayOfMonth,
            decoration: const InputDecoration(labelText: 'Monthly rule'),
            items: MonthlyRecurrenceKind.values.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(_monthlyKindLabel(value)),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              onChanged(_ruleForMonthlyKind(value, normalized));
            },
          ),
          context.gapMD,
          if ((normalized.monthlyKind ?? MonthlyRecurrenceKind.dayOfMonth) ==
              MonthlyRecurrenceKind.dayOfMonth)
            DropdownButtonFormField<int>(
              initialValue: normalized.dayOfMonth ?? 1,
              decoration: const InputDecoration(labelText: 'Day of month'),
              items: _numberOptions(1, 31).map((value) {
                return DropdownMenuItem(value: value, child: Text('$value'));
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                onChanged(normalized.copyWith(dayOfMonth: value));
              },
            )
          else
            Row(
              children: [
                if (normalized.monthlyKind ==
                    MonthlyRecurrenceKind.nthWeekday) ...[
                  DropdownButtonFormField<int>(
                    initialValue: normalized.weekOfMonth ?? 1,
                    decoration: const InputDecoration(labelText: 'Week'),
                    items: _numberOptions(1, 4).map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(_capitalizedOrdinal(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      onChanged(normalized.copyWith(weekOfMonth: value));
                    },
                  ).expanded(),
                  context.gapSM,
                ],
                DropdownButtonFormField<int>(
                  initialValue: normalized.weekday ?? DateTime.monday,
                  decoration: const InputDecoration(labelText: 'Weekday'),
                  items: _weekdays.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(weekdayLabel(value)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    onChanged(normalized.copyWith(weekday: value));
                  },
                ).expanded(),
              ],
            ),
        ],
      ],
    );
  }
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

String _dateMetaLabel(Chore chore) {
  if (chore.nextDue == null) return 'No due date';
  final prefix = chore.type == ChoreType.recurring ? 'Next due' : 'Due';
  return '$prefix ${_formatDueDate(chore.nextDue)}';
}

String _formatDueDate(DateTime? date) {
  if (date == null) return '';
  return '${date.day}/${date.month}/${date.year}';
}

String _viewLabel(ChoreView view) {
  switch (view) {
    case ChoreView.due:
      return 'Due';
    case ChoreView.todos:
      return 'Todo';
    case ChoreView.recurring:
      return 'Recurring';
    case ChoreView.areas:
      return 'Area';
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

const _weekdays = <int>[
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
  DateTime.sunday,
];

List<int> _numberOptions(int min, int max) {
  return [for (var value = min; value <= max; value++) value];
}

String _frequencyLabel(RecurrenceFrequency frequency) {
  switch (frequency) {
    case RecurrenceFrequency.daily:
      return 'Daily';
    case RecurrenceFrequency.weekly:
      return 'Weekly';
    case RecurrenceFrequency.monthly:
      return 'Monthly';
  }
}

String _monthlyKindLabel(MonthlyRecurrenceKind kind) {
  switch (kind) {
    case MonthlyRecurrenceKind.dayOfMonth:
      return 'Day of month';
    case MonthlyRecurrenceKind.nthWeekday:
      return 'Nth weekday';
    case MonthlyRecurrenceKind.lastWeekday:
      return 'Last weekday';
  }
}

String _capitalizedOrdinal(int value) {
  final label = ordinalLabel(value);
  return '${label[0].toUpperCase()}${label.substring(1)}';
}

RecurrenceRule _ruleForFrequency(
  RecurrenceFrequency frequency,
  RecurrenceRule current,
) {
  switch (frequency) {
    case RecurrenceFrequency.daily:
      return RecurrenceRule.daily(interval: current.interval);
    case RecurrenceFrequency.weekly:
      return RecurrenceRule.weekly(
        interval: current.interval,
        weekday: current.weekday ?? DateTime.monday,
      );
    case RecurrenceFrequency.monthly:
      return RecurrenceRule.monthlyDay(
        interval: current.interval,
        dayOfMonth: current.dayOfMonth ?? 1,
      );
  }
}

RecurrenceRule _ruleForMonthlyKind(
  MonthlyRecurrenceKind kind,
  RecurrenceRule current,
) {
  switch (kind) {
    case MonthlyRecurrenceKind.dayOfMonth:
      return RecurrenceRule.monthlyDay(
        interval: current.interval,
        dayOfMonth: current.dayOfMonth ?? 1,
      );
    case MonthlyRecurrenceKind.nthWeekday:
      return RecurrenceRule.monthlyNthWeekday(
        interval: current.interval,
        weekOfMonth: current.weekOfMonth ?? 1,
        weekday: current.weekday ?? DateTime.monday,
      );
    case MonthlyRecurrenceKind.lastWeekday:
      return RecurrenceRule.monthlyLastWeekday(
        interval: current.interval,
        weekday: current.weekday ?? DateTime.monday,
      );
  }
}
