import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
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
        final theme = FTheme.of(context);

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Today\'s Chores',
                      style: theme.typography.xl.copyWith(
                        color: theme.colors.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FBadge(
                    style: dashboardState.attentionCount > 0
                        ? FBadgeStyle.destructive()
                        : FBadgeStyle.secondary(),
                    child: Text(dashboardState.attentionCount.toString()),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingXS),
              Text(
                'What needs attention today',
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMD),
              if (dashboardState.attentionCount == 0)
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
                  child: ListView(
                    children: [
                      if (dashboardState.overdue.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Overdue',
                          count: dashboardState.overdue.length,
                          destructive: true,
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        _TodayChoreGroup(
                          chores: dashboardState.overdue,
                          overdue: true,
                        ),
                        const SizedBox(height: AppConstants.spacingMD),
                      ],
                      if (dashboardState.today.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Today',
                          count: dashboardState.today.length,
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        _TodayChoreGroup(chores: dashboardState.today),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: AppConstants.spacingSM),
              FButton(
                style: FButtonStyle.outline(),
                onPress: () => context.go(AppRoutePath.chores),
                prefix: const Icon(Icons.arrow_forward_rounded, size: 16),
                child: const Text('Open chore manager'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.count,
    this.destructive = false,
  });

  final String label;
  final int count;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final color = destructive
        ? theme.colors.destructive
        : theme.colors.foreground;

    return Row(
      children: [
        Text(
          label,
          style: theme.typography.sm.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppConstants.spacingSM),
        FBadge(
          style: destructive
              ? FBadgeStyle.destructive()
              : FBadgeStyle.secondary(),
          child: Text(count.toString()),
        ),
      ],
    );
  }
}

class _TodayChoreGroup extends ConsumerWidget {
  const _TodayChoreGroup({required this.chores, this.overdue = false});

  final List<Chore> chores;
  final bool overdue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FTheme.of(context);

    return FItemGroup(
      divider: FItemDivider.full,
      semanticsLabel: overdue ? 'Overdue chores' : 'Chores due today',
      children: [
        for (final chore in chores)
          FItem(
            title: Text(
              chore.title,
              style: theme.typography.base.copyWith(
                color: theme.colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${chore.scheduleLabel} · ${chore.assignedTo} · ${_formatDue(chore.nextDue)}',
              style: theme.typography.xs.copyWith(
                color: overdue
                    ? theme.colors.destructive
                    : theme.colors.mutedForeground,
                fontWeight: overdue ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            prefix: _ChoreIcon(chore: chore, overdue: overdue),
            details: FBadge(
              style: FBadgeStyle.outline(),
              child: Text(chore.area),
            ),
            suffix: Semantics(
              button: true,
              label: 'Mark ${chore.title} completed',
              child: FButton.icon(
                style: FButtonStyle.ghost(),
                onPress: () =>
                    ref.read(choreControllerProvider).completeChore(chore),
                child: const Icon(Icons.check_rounded),
              ),
            ),
          ),
      ],
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
        dimension: 40,
        child: Icon(
          chore.type == ChoreType.recurring
              ? recurringChoreIcon(chore.iconKey)
              : Icons.task_alt_rounded,
          size: 19,
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
