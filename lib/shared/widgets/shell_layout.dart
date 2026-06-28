import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/shared/widgets/sidebar_menu.dart';

class ShellLayout extends StatelessWidget {
  final Widget child;

  const ShellLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF1ECE3),
              const Color(0xFFE7E1D8),
              const Color(0xFFD8E2D8),
            ],
            stops: const [0, 0.56, 1],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -90,
              left: 150,
              child: _AmbientGlow(
                size: 360,
                color: const Color(0xFFEFB8AD).withValues(alpha: 0.18),
              ),
            ),
            Positioned(
              right: -80,
              bottom: -120,
              child: _AmbientGlow(
                size: 420,
                color: const Color(0xFFA9BFA9).withValues(alpha: 0.22),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                child: Row(
                  spacing: AppConstants.spacingLG,
                  children: [
                    const SidebarMenu(),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _AmbientGlow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
