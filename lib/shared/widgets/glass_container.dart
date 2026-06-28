import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habi/config/theme/theme_extensions.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final bool isElevated;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.isElevated = false,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? context.radiusXL;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLowest.withValues(
              alpha: context.isDarkMode ? 0.76 : 0.84,
            ),
            borderRadius: radius,
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(
                alpha: context.isDarkMode ? 0.34 : 0.92,
              ),
            ),
            boxShadow: [
              if (isElevated)
                BoxShadow(
                  color: context.colorScheme.shadow.withValues(
                    alpha: context.isDarkMode ? 0.34 : 0.14,
                  ),
                  blurRadius: 42,
                  spreadRadius: -12,
                  offset: const Offset(0, 24),
                ),
              if (!context.isDarkMode)
                BoxShadow(
                  color: context.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.72,
                  ),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              BoxShadow(
                color: context.colorScheme.shadow.withValues(
                  alpha: context.isDarkMode ? 0.10 : 0.035,
                ),
                blurRadius: 10,
                spreadRadius: -8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}

class AppSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppSurface({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      isElevated: true,
      padding: padding ?? context.paddingLG,
      child: child,
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final bool emphasized;

  const StatusChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: emphasized ? 0.18 : 0.11),
        borderRadius: context.radiusFull,
        border: Border.all(color: chipColor.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: chipColor),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? context.colorScheme.primary;

    return GlassContainer(
      isElevated: true,
      padding: context.paddingMD,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.22),
                  context.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.36,
                  ),
                ],
              ),
              borderRadius: context.radiusLG,
              border: Border.all(color: accent.withValues(alpha: 0.16)),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          context.gapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
