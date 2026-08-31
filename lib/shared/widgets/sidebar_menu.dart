import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/app_constants.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final theme = FTheme.of(context);

    return FSidebar(
      width: 72,
      style: (style) => style.copyWith(
        constraints: const BoxConstraints.tightFor(width: 72),
        headerPadding: const EdgeInsets.all(AppConstants.spacingSM),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXS,
          vertical: AppConstants.spacingMD,
        ),
        decoration: BoxDecoration(
          color: theme.colors.background,
          border: Border.all(color: theme.colors.border),
          borderRadius: theme.style.borderRadius,
        ),
      ),
      header: const _HabiMark(),
      children: [
        _NavItem(
          icon: Icons.home_rounded,
          label: 'Dashboard',
          selected: currentPath == AppRoutePath.dashboard,
          onPress: () => context.go(AppRoutePath.dashboard),
        ),
        _NavItem(
          assetPath: 'lib/assets/svg/airbnb-icon.svg',
          label: 'Airbnb',
          selected: currentPath == AppRoutePath.airbnb,
          onPress: () => context.go(AppRoutePath.airbnb),
        ),
        _NavItem(
          icon: Icons.calendar_month_rounded,
          label: 'Calendar',
          selected: currentPath == AppRoutePath.calendar,
          onPress: () => context.go(AppRoutePath.calendar),
        ),
        _NavItem(
          icon: Icons.cleaning_services_rounded,
          label: 'Chores',
          selected: currentPath == AppRoutePath.chores,
          onPress: () => context.go(AppRoutePath.chores),
        ),
      ],
    );
  }
}

class _HabiMark extends StatelessWidget {
  const _HabiMark();

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.secondary,
        borderRadius: theme.style.borderRadius,
      ),
      child: SizedBox.square(
        dimension: 48,
        child: Center(
          child: SvgPicture.asset(
            'lib/assets/svg/habi_logo.svg',
            height: 27,
            semanticsLabel: 'Habi',
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onPress,
    this.icon,
    this.assetPath,
  });

  final IconData? icon;
  final String? assetPath;
  final String label;
  final bool selected;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final colors = FTheme.of(context).colors;
    final color = selected ? colors.foreground : colors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingXS),
      child: Align(
        child: SizedBox.square(
          dimension: 48,
          child: Semantics(
            button: true,
            selected: selected,
            label: label,
            child: FSidebarItem(
              style: (style) => style.copyWith(
                padding: const EdgeInsets.all(14),
                backgroundColor: FWidgetStateMap({
                  WidgetState.selected: colors.secondary,
                  WidgetState.hovered | WidgetState.pressed: colors.muted,
                  WidgetState.any: Colors.transparent,
                }),
                iconStyle: FWidgetStateMap({
                  WidgetState.selected: IconThemeData(
                    color: colors.foreground,
                    size: 20,
                  ),
                  WidgetState.any: IconThemeData(color: color, size: 20),
                }),
              ),
              selected: selected,
              onPress: onPress,
              icon: assetPath == null
                  ? Icon(icon, semanticLabel: label)
                  : SvgPicture.asset(
                      assetPath!,
                      width: 20,
                      height: 20,
                      semanticsLabel: label,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
