import 'package:flutter/material.dart';
import 'package:habi/features/dashboard/widgets/remainders_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Dashboard')),
          ),
        ),
        Expanded(flex: 1, child: RemaindersSection()),
      ],
    );
  }
}
