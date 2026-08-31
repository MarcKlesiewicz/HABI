import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/features/chores/application/chore_queries.dart';
import 'package:habi/features/chores/application/chore_providers.dart';
import 'package:habi/features/chores/data/chore_store.dart';
import 'package:habi/features/chores/presentation/chore_visuals.dart';
import 'package:habi/shared/widgets/app_card.dart';

class ActiveChoresSection extends ConsumerWidget {
  const ActiveChoresSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choresState = ref.watch(choresProvider);

    return choresState.when(
      loading: () => const AppCard(child: Center(child: FCircularProgress())),
      error: (error, _) => AppCard(
        child: Center(
          child: FAlert(
            style: FAlertStyle.destructive(),
            title: const Text('Could not load chores'),
            subtitle: Text(error.toString()),
          ),
        ),
      ),
      data: (chores) {
        final dashboardState = dashboardChores(chores);
        final dueChores = [...dashboardState.overdue, ...dashboardState.today];
        final theme = FTheme.of(context);

        return AppCard(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colors.secondary,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMD,
                      ),
                    ),
                    child: SizedBox.square(
                      dimension: AppConstants.buttonHeight,
                      child: Icon(
                        Icons.checklist_rounded,
                        color: theme.colors.secondaryForeground,
                        semanticLabel: 'Today\'s chores',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Chores',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.xl.copyWith(
                            color: theme.colors.foreground,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingXS),
                        Text(
                          'What needs attention today',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.xs.copyWith(
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  FBadge(
                    style: dashboardState.attentionCount > 0
                        ? FBadgeStyle.destructive()
                        : FBadgeStyle.secondary(),
                    child: Text(dashboardState.attentionCount.toString()),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMD),
              if (dueChores.isEmpty)
                const Expanded(
                  child: Center(
                    child: FAlert(
                      icon: Icon(Icons.check_circle_outline_rounded),
                      title: Text('All clear'),
                      subtitle: Text('No chores are due today.'),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: dueChores.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: theme.colors.border),
                    itemBuilder: (context, index) => _CompactChoreRow(
                      chore: dueChores[index],
                      overdue: index < dashboardState.overdue.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CompactChoreRow extends ConsumerWidget {
  const _CompactChoreRow({required this.chore, required this.overdue});

  final Chore chore;
  final bool overdue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSM),
      child: Row(
        children: [
          _ChoreIcon(chore: chore, overdue: overdue),
          const SizedBox(width: AppConstants.spacingSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chore.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXS),
                Text(
                  '${chore.assignedTo} - ${_formatDue(chore.nextDue)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.xs.copyWith(
                    color: overdue
                        ? theme.colors.destructive
                        : theme.colors.mutedForeground,
                    fontWeight: overdue ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingSM),
          FBadge(style: FBadgeStyle.outline(), child: Text(chore.area)),
          Semantics(
            button: true,
            label: 'Mark ${chore.title} completed',
            child: FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: () =>
                  ref.read(choreControllerProvider).completeChore(chore),
              child: const Icon(Icons.check_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoreIcon extends StatelessWidget {
  const _ChoreIcon({required this.chore, required this.overdue});

  final Chore chore;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final accent = overdue
        ? theme.colors.destructive
        : chore.type == ChoreType.recurring
        ? recurringChoreColor(context, chore.colorKey)
        : theme.colors.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: theme.style.borderRadius,
      ),
      child: SizedBox.square(
        dimension: 34,
        child: Icon(
          chore.type == ChoreType.recurring
              ? recurringChoreIcon(chore.iconKey)
              : Icons.task_alt_rounded,
          size: 17,
          color: accent,
        ),
      ),
    );
  }
}

String _formatDue(DateTime? date) {
  if (date == null) return 'no due date';
  return 'due ${date.day}/${date.month}';
}
