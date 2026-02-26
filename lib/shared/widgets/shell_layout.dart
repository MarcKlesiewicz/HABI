import 'package:flutter/material.dart';
import 'package:habi/shared/widgets/sidebar_menu.dart';

class ShellLayout extends StatelessWidget {
  final Widget child;

  const ShellLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 16,
          children: [
            SidebarMenu(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
