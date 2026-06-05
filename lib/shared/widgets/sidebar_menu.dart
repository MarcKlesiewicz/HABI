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
      child: SizedBox(
        width: 64,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: context.radiusSM,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/svg/habi_logo.svg',
                  height: 26,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLG),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _NavIconButton(
                  icon: Icons.dashboard,
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
                  icon: Icons.calendar_month,
                  tooltip: 'Calendar',
                  isSelected: currentPath == AppRoutePath.calendar,
                  onPressed: () => context.go(AppRoutePath.calendar),
                ),
                const SizedBox(height: AppConstants.spacingSM),
                _NavIconButton(
                  icon: Icons.cleaning_services,
                  tooltip: 'Chores',
                  isSelected: currentPath == AppRoutePath.chores,
                  onPressed: () => context.go(AppRoutePath.chores),
                ),
              ],
            ),
          ],
        ),
      ).paddingAll(AppConstants.spacingSM),
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
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: isSelected
              ? context.colorScheme.primary
              : Colors.transparent,
          foregroundColor: isSelected
              ? context.colorScheme.onPrimary
              : context.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: context.radiusSM),
        ),
        icon: assetPath == null
            ? Icon(icon, size: 20)
            : SvgPicture.asset(
                assetPath!,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}
