import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return GlassContainer(
      isElevated: true,
      padding: const EdgeInsets.all(AppConstants.spacingSM),
      child: SizedBox(
        width: 68,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colorScheme.surfaceContainerLowest.withValues(
                      alpha: 0.82,
                    ),
                    context.colorScheme.primaryContainer.withValues(
                      alpha: 0.55,
                    ),
                  ],
                ),
                borderRadius: context.radiusLG,
                border: Border.all(
                  color: context.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.68,
                  ),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/svg/habi_logo.svg',
                  height: 27,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXL),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _NavIconButton(
                  icon: Icons.dashboard_rounded,
                  tooltip: 'Dashboard',
                  isSelected: currentPath == AppRoutePath.dashboard,
                  onPressed: () => context.go(AppRoutePath.dashboard),
                ),
                const SizedBox(height: AppConstants.spacingSM),
                _NavIconButton(
                  assetPath: 'lib/assets/svg/airbnb-icon.svg',
                  tooltip: 'Airbnb',
                  isSelected: currentPath == AppRoutePath.airbnb,
                  onPressed: () => context.go(AppRoutePath.airbnb),
                ),
                const SizedBox(height: AppConstants.spacingSM),
                _NavIconButton(
                  icon: Icons.calendar_month_rounded,
                  tooltip: 'Calendar',
                  isSelected: currentPath == AppRoutePath.calendar,
                  onPressed: () => context.go(AppRoutePath.calendar),
                ),
                const SizedBox(height: AppConstants.spacingSM),
                _NavIconButton(
                  icon: Icons.cleaning_services_rounded,
                  tooltip: 'Chores',
                  isSelected: currentPath == AppRoutePath.chores,
                  onPressed: () => context.go(AppRoutePath.chores),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onPressed;

  const _NavIconButton({
    this.icon,
    this.assetPath,
    required this.tooltip,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? context.colorScheme.onSurface
        : context.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 48,
      height: 48,
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        curve: AppConstants.curveDefault,
        decoration: BoxDecoration(
          borderRadius: context.radiusLG,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: isSelected
                ? context.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.72,
                  )
                : Colors.transparent,
            foregroundColor: foreground,
            shape: RoundedRectangleBorder(
              borderRadius: context.radiusLG,
              side: BorderSide(
                color: isSelected
                    ? context.colorScheme.primary.withValues(alpha: 0.18)
                    : Colors.transparent,
              ),
            ),
          ),
          icon: assetPath == null
              ? Icon(icon, size: 22)
              : SvgPicture.asset(
                  assetPath!,
                  width: 21,
                  height: 21,
                  colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                ),
        ),
      ),
    );
  }
}
