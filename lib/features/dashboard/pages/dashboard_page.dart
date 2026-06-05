import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/dashboard/widgets/active_chores_section.dart';
import 'package:habi/features/upcoming_events/presentation/upcoming_events_section.dart';

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
        ActiveChoresSection().expanded(flex: 2),
        UpcomingEventsSection().expanded(flex: 1),
      ],
    );
  }
}
