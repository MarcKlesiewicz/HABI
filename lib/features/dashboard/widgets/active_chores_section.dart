import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/chores/data/chore_store.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class ActiveChoresSection extends StatelessWidget {
  const ActiveChoresSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ChoreStore.instance,
      builder: (context, _) {
        final chores = ChoreStore.instance.chores;
        final todayChores = _todayChores(chores);
        final overdueChores = _overdueChores(chores);
        final attentionCount = todayChores.length + overdueChores.length;

        return GlassContainer(
          child: Padding(
            padding: context.paddingMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Today\'s Chores',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      attentionCount.toString(),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
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
                if (attentionCount == 0)
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
                        if (overdueChores.isNotEmpty) ...[
                          _SectionLabel(
                            label: 'Overdue',
                            count: overdueChores.length,
                          ),
                          context.gapSM,
                          ...overdueChores.expand((chore) {
                            return [
                              _TodayChoreTile(chore: chore, isOverdue: true),
                              context.gapSM,
                            ];
                          }),
                          context.gapSM,
                        ],
                        if (todayChores.isNotEmpty) ...[
                          _SectionLabel(
                            label: 'Today',
                            count: todayChores.length,
                          ),
                          context.gapSM,
                          ...todayChores.expand((chore) {
                            return [
                              _TodayChoreTile(chore: chore),
                              context.gapSM,
                            ];
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
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Open chore manager'),
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
            color: context.colorScheme.secondary,
            fontWeight: FontWeight.bold,
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

class _TodayChoreTile extends StatelessWidget {
  final Chore chore;
  final bool isOverdue;

  const _TodayChoreTile({required this.chore, this.isOverdue = false});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Padding(
        padding: context.paddingSM,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isOverdue
                    ? context.colorScheme.errorContainer
                    : context.colorScheme.primary.withValues(alpha: 0.22),
                borderRadius: context.radiusSM,
              ),
              child: Icon(
                chore.type == ChoreType.recurring
                    ? Icons.event_repeat
                    : Icons.task_alt,
                size: 20,
                color: context.colorScheme.secondary,
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
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
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
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSM,
                vertical: AppConstants.spacingXS,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.22),
                borderRadius: context.radiusXS,
              ),
              child: Text(
                chore.area,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            context.gapSM,
            IconButton(
              tooltip: 'Mark completed',
              onPressed: () => ChoreStore.instance.completeChore(chore.id),
              icon: const Icon(Icons.check_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}

List<Chore> _todayChores(List<Chore> chores) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return chores
      .where((chore) {
        if (!_isDashboardCandidate(chore)) return false;
        final due = chore.nextDue;
        if (due == null) return false;
        final dueDay = DateTime(due.year, due.month, due.day);
        return dueDay.isAtSameMomentAs(today);
      })
      .toList(growable: false)
    ..sort(_compareDue);
}

List<Chore> _overdueChores(List<Chore> chores) {
  final now = DateTime.now();
  return chores
      .where((chore) {
        if (!_isDashboardCandidate(chore)) return false;
        return chore.isOverdue(now);
      })
      .toList(growable: false)
    ..sort(_compareDue);
}

bool _isDashboardCandidate(Chore chore) {
  return chore.isActive &&
      !chore.isDone &&
      chore.type != ChoreType.unscheduled &&
      chore.nextDue != null;
}

int _compareDue(Chore a, Chore b) {
  return a.nextDue!.compareTo(b.nextDue!);
}

String _formatDue(DateTime? date) {
  if (date == null) return 'no due date';
  return 'due ${date.day}/${date.month}';
}
