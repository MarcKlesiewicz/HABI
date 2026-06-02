import 'package:flutter/material.dart';
import 'package:habi/config/theme/theme_extensions.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final bool isElevated;

  const GlassContainer({
    super.key,
    required this.child,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: context.radiusSM,
        border: Border.all(color: context.colorScheme.outlineVariant),
        boxShadow: isElevated
            ? [
                BoxShadow(
                  color: context.colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: ClipRRect(borderRadius: context.radiusSM, child: child),
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
      child: Padding(padding: padding ?? context.paddingMD, child: child),
    );
  }
}
