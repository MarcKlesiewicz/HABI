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
              const Color(0xFFF5CAC9),
              const Color(0xFFE8DDD8),
              const Color(0xFFDADFCE),
            ],
            stops: const [0, 0.48, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Row(
              spacing: AppConstants.spacingMD,
              children: [
                const SidebarMenu(),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
