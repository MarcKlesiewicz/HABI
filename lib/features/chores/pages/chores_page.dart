import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/chores/data/chore_store.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class ChoresPage extends StatelessWidget {
  const ChoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ChoreStore.instance,
      builder: (context, _) {
        final chores = ChoreStore.instance.chores;
        final activeCount = chores.where((chore) => chore.isActive).length;
        final recurringCount = chores
            .where((chore) => chore.type == ChoreType.recurring)
            .length;

        return GlassContainer(
          isElevated: true,
          child: Padding(
            padding: context.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            '$activeCount active - $recurringCount recurring - ${chores.length - recurringCount} single',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _showChoreDialog(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add chore'),
                    ),
                  ],
                ),
                context.gapLG,
                Expanded(
                  child: ListView.separated(
                    itemCount: chores.length,
                    separatorBuilder: (_, _) => context.gapSM,
                    itemBuilder: (context, index) {
                      return _ChoreTile(chore: chores[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChoreTile extends StatelessWidget {
  final Chore chore;

  const _ChoreTile({required this.chore});

  @override
  Widget build(BuildContext context) {
    final isSingle = chore.type == ChoreType.single;

    return GlassContainer(
      child: Padding(
        padding: context.paddingMD,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: chore.isActive
                    ? context.colorScheme.primary.withValues(alpha: 0.22)
                    : context.colorScheme.surfaceContainerHigh,
                borderRadius: context.radiusSM,
              ),
              child: Icon(
                isSingle ? Icons.task_alt : Icons.event_repeat,
                color: context.colorScheme.secondary,
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
                      _ChoreMeta(
                        icon: Icons.schedule,
                        label: chore.scheduleLabel,
                      ),
                      _ChoreMeta(icon: Icons.person, label: chore.assignedTo),
                      _ChoreMeta(
                        icon: Icons.calendar_today,
                        label: _formatDueDate(chore.nextDue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            context.gapSM,
            if (isSingle)
              Checkbox(
                value: chore.isDone,
                onChanged: (_) => ChoreStore.instance.toggleDone(chore.id),
              ),
            Switch(
              value: chore.isActive,
              onChanged: (_) => ChoreStore.instance.toggleActive(chore.id),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _showChoreDialog(context, chore: chore);
                  return;
                }
                if (value == 'delete') {
                  _confirmDelete(context, chore);
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
    final isRecurring = chore.type == ChoreType.recurring;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSM,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isRecurring
            ? context.colorScheme.primary.withValues(alpha: 0.2)
            : context.colorScheme.tertiaryContainer,
        borderRadius: context.radiusXS,
      ),
      child: Text(
        isRecurring ? 'Recurring' : 'Single',
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

  const _ChoreMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

Future<void> _showChoreDialog(BuildContext context, {Chore? chore}) async {
  final isEditing = chore != null;
  final titleController = TextEditingController(text: chore?.title ?? '');
  final areaController = TextEditingController(text: chore?.area ?? '');
  final assignedToController = TextEditingController(
    text: chore?.assignedTo ?? '',
  );
  final recurrenceController = TextEditingController(
    text: chore?.recurrence ?? '',
  );
  var type = chore?.type ?? ChoreType.recurring;
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
              width: 460,
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
                          label: 'Single task',
                          isSelected: type == ChoreType.single,
                          onPressed: () {
                            setDialogState(() => type = ChoreType.single);
                          },
                        ).expanded(),
                      ],
                    ),
                    context.gapMD,
                    TextField(
                      controller: areaController,
                      decoration: const InputDecoration(labelText: 'Area'),
                    ),
                    context.gapMD,
                    TextField(
                      controller: assignedToController,
                      decoration: const InputDecoration(
                        labelText: 'Assigned to',
                      ),
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
                    ],
                    context.gapMD,
                    Row(
                      children: [
                        Expanded(child: Text('Due ${_formatDueDate(dueDate)}')),
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
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() => isActive = value);
                      },
                    ),
                    if (type == ChoreType.single)
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
                  final area = areaController.text.trim();
                  final assignedTo = assignedToController.text.trim();
                  final recurrence = recurrenceController.text.trim();

                  if (title.isEmpty || area.isEmpty || assignedTo.isEmpty) {
                    return;
                  }

                  final savedChore = Chore(
                    id: chore?.id ?? ChoreStore.instance.nextId(),
                    title: title,
                    area: area,
                    type: type,
                    recurrence:
                        type == ChoreType.recurring && recurrence.isNotEmpty
                        ? recurrence
                        : null,
                    assignedTo: assignedTo,
                    nextDue: dueDate,
                    isActive: isActive,
                    isDone: type == ChoreType.single ? isDone : false,
                  );

                  if (isEditing) {
                    ChoreStore.instance.updateChore(savedChore);
                  } else {
                    ChoreStore.instance.createChore(savedChore);
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
    return SizedBox(
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerHigh,
          foregroundColor: isSelected
              ? context.colorScheme.onPrimary
              : context.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: context.radiusSM),
        ),
        child: Text(label),
      ),
    );
  }
}

Future<void> _confirmDelete(BuildContext context, Chore chore) async {
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
    ChoreStore.instance.deleteChore(chore.id);
  }
}

String _formatDueDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
