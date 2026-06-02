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

        return GlassContainer(
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
                            'Recurring Chores',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: context.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          context.gapXS,
                          Text(
                            '$activeCount active of ${chores.length}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.cleaning_services,
                      color: context.colorScheme.secondary,
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
                    ? context.colorScheme.secondary.withValues(alpha: 0.18)
                    : context.colorScheme.surface.withValues(alpha: 0.35),
                borderRadius: context.radiusSM,
              ),
              child: Icon(
                chore.isActive ? Icons.event_repeat : Icons.pause_circle,
                color: context.colorScheme.secondary,
              ),
            ),
            context.gapMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chore.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  context.gapXS,
                  Wrap(
                    spacing: AppConstants.spacingSM,
                    runSpacing: AppConstants.spacingXS,
                    children: [
                      _ChoreMeta(icon: Icons.place, label: chore.area),
                      _ChoreMeta(icon: Icons.schedule, label: chore.cadence),
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
            Switch(
              value: chore.isActive,
              onChanged: (_) => ChoreStore.instance.toggleActive(chore.id),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    return 'Due ${date.day}/${date.month}';
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
