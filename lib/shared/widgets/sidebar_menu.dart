import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          GestureDetector(
            onTap: () => context.go(AppRoutePath.dashboard),
            child: Icon(Icons.dashboard, color: Colors.white),
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutePath.airbnb),
            child: Icon(Icons.settings, color: Colors.white),
          ),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
