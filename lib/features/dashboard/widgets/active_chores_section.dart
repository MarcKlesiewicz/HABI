import 'package:flutter/material.dart';
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
        final chores = ChoreStore.instance.activeChores;

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
                        'Active Chores',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      chores.length.toString(),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                context.gapMD,
                if (chores.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No active chores',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: chores.length,
                      separatorBuilder: (_, _) => context.gapSM,
                      itemBuilder: (context, index) {
                        return _ActiveChoreTile(chore: chores[index]);
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

class _ActiveChoreTile extends StatelessWidget {
  final Chore chore;

  const _ActiveChoreTile({required this.chore});

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
                color: context.colorScheme.secondary.withValues(alpha: 0.18),
                borderRadius: context.radiusSM,
              ),
              child: Icon(
                Icons.checklist,
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
                    '${chore.scheduleLabel} - ${chore.assignedTo} - due ${chore.nextDue.day}/${chore.nextDue.month}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
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
          ],
        ),
      ),
    );
  }
}
