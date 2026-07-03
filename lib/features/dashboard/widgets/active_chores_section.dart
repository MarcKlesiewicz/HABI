import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/chores/application/chore_queries.dart';
import 'package:habi/features/chores/application/chore_providers.dart';
import 'package:habi/features/chores/data/chore_store.dart';
import 'package:habi/features/chores/presentation/chore_visuals.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class ActiveChoresSection extends ConsumerWidget {
  const ActiveChoresSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choresState = ref.watch(choresProvider);

    return choresState.when(
      loading: () => const GlassContainer(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => GlassContainer(
        child: Padding(
          padding: context.paddingMD,
          child: Text('Could not load chores: $error'),
        ),
      ),
      data: (chores) {
        final dashboardState = dashboardChores(chores);

        return GlassContainer(
          isElevated: true,
          padding: context.paddingLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Today\'s Chores',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  StatusChip(
                    label: dashboardState.attentionCount.toString(),
                    color: dashboardState.attentionCount > 0
                        ? context.colorScheme.primary
                        : context.colorScheme.tertiary,
                    emphasized: dashboardState.attentionCount > 0,
                  ),
                ],
              ),
              context.gapXS,
              Text(
                'What needs attention today',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              context.gapMD,
              if (dashboardState.attentionCount == 0)
                Expanded(
                  child: Center(
                    child: Text(
                      'No chores due today',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      if (dashboardState.overdue.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Overdue',
                          count: dashboardState.overdue.length,
                        ),
                        context.gapSM,
                        ...dashboardState.overdue.expand((chore) {
                          return [
                            _TodayChoreTile(chore: chore, isOverdue: true),
                            context.gapSM,
                          ];
                        }),
                        context.gapSM,
                      ],
                      if (dashboardState.today.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Today',
                          count: dashboardState.today.length,
                        ),
                        context.gapSM,
                        ...dashboardState.today.expand((chore) {
                          return [_TodayChoreTile(chore: chore), context.gapSM];
                        }),
                      ],
                    ],
                  ),
                ),
              context.gapSM,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutePath.chores),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Open chore manager'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;

  const _SectionLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        context.gapSM,
        Text(
          count.toString(),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TodayChoreTile extends ConsumerWidget {
  final Chore chore;
  final bool isOverdue;

  const _TodayChoreTile({required this.chore, this.isOverdue = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  (isOverdue
                          ? context.colorScheme.error
                          : chore.type == ChoreType.recurring
                          ? recurringChoreColor(context, chore.colorKey)
                          : context.colorScheme.primary)
                      .withValues(alpha: 0.14),
              borderRadius: context.radiusLG,
            ),
            child: Icon(
              chore.type == ChoreType.recurring
                  ? recurringChoreIcon(chore.iconKey)
                  : Icons.task_alt,
              size: 20,
              color: isOverdue
                  ? context.colorScheme.error
                  : context.colorScheme.onSurface,
            ),
          ),
          context.gapSM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chore.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                context.gapXS,
                Text(
                  '${chore.scheduleLabel} - ${chore.assignedTo} - ${_formatDue(chore.nextDue)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isOverdue
                        ? context.colorScheme.error
                        : context.colorScheme.onSurfaceVariant,
                    fontWeight: isOverdue ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
          StatusChip(label: chore.area, color: context.colorScheme.tertiary),
          context.gapSM,
          IconButton(
            tooltip: 'Mark completed',
            onPressed: () =>
                ref.read(choreControllerProvider).completeChore(chore),
            icon: const Icon(Icons.check_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}

String _formatDue(DateTime? date) {
  if (date == null) return 'no due date';
  return 'due ${date.day}/${date.month}';
}
