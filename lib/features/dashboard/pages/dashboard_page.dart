import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/features/dashboard/widgets/active_chores_section.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_events_section.dart';
import 'package:habi/shared/widgets/app_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < AppConstants.breakpointTablet;

        if (compact) {
          return ListView(
            children: [
              const SizedBox(
                height: 280,
                child: _DashboardPlaceholderCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Highlights',
                  subtitle: 'A focused overview of your home will live here.',
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(
                height: 240,
                child: _DashboardPlaceholderCard(
                  icon: Icons.bed_outlined,
                  title: 'Next Airbnb',
                  subtitle: 'Your next reservation will live here.',
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(height: 440, child: ActiveChoresSection()),
              const SizedBox(height: AppConstants.spacingLG),
              const SizedBox(height: 440, child: UpcomingEventsSection()),
            ],
          );
        }

        return Row(
          spacing: AppConstants.spacingLG,
          children: const [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppConstants.spacingLG,
                children: [
                  Expanded(
                    flex: 2,
                    child: _DashboardPlaceholderCard(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Highlights',
                      subtitle:
                          'A focused overview of your home will live here.',
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      spacing: AppConstants.spacingLG,
                      children: [
                        Expanded(
                          child: _DashboardPlaceholderCard(
                            icon: Icons.bed_outlined,
                            title: 'Next Airbnb',
                            subtitle: 'Your next reservation will live here.',
                          ),
                        ),
                        Expanded(child: ActiveChoresSection()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: UpcomingEventsSection()),
          ],
        );
      },
    );
  }
}

class _DashboardPlaceholderCard extends StatelessWidget {
  const _DashboardPlaceholderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colors.secondary,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
            child: SizedBox.square(
              dimension: AppConstants.buttonHeight,
              child: Icon(
                icon,
                color: theme.colors.secondaryForeground,
                semanticLabel: title,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: theme.typography.xl.copyWith(
              color: theme.colors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            subtitle,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
