import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/dashboard/widgets/reminders_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppConstants.spacingMD,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text('Dashboard')),
        ).expanded(flex: 2),
        RemaindersSection().expanded(flex: 1),
      ],
    );
  }
}
