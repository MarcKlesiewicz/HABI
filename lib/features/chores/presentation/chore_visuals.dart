import 'package:flutter/material.dart';
import 'package:habi/features/chores/data/chore_store.dart';

IconData recurringChoreIcon(String key) {
  switch (key) {
    case 'alarm':
      return Icons.alarm;
    case 'auto_awesome':
      return Icons.auto_awesome;
    case 'bathtub':
      return Icons.bathtub;
    case 'bed':
      return Icons.bed;
    case 'build':
      return Icons.build;
    case 'calendar_month':
      return Icons.calendar_month;
    case 'car_repair':
      return Icons.car_repair;
    case 'check_circle':
      return Icons.check_circle;
    case 'delete_outline':
      return Icons.delete_outline;
    case 'directions_car':
      return Icons.directions_car;
    case 'dishwasher':
      return Icons.kitchen;
    case 'dry_cleaning':
      return Icons.dry_cleaning;
    case 'electrical_services':
      return Icons.electrical_services;
    case 'emoji_nature':
      return Icons.emoji_nature;
    case 'event_available':
      return Icons.event_available;
    case 'favorite':
      return Icons.favorite;
    case 'fire_extinguisher':
      return Icons.fire_extinguisher;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'garage':
      return Icons.garage;
    case 'handyman':
      return Icons.handyman;
    case 'heat_pump':
      return Icons.thermostat;
    case 'home':
      return Icons.home;
    case 'iron':
      return Icons.iron;
    case 'lightbulb':
      return Icons.lightbulb;
    case 'local_laundry_service':
      return Icons.local_laundry_service;
    case 'local_shipping':
      return Icons.local_shipping;
    case 'lock':
      return Icons.lock;
    case 'mop':
      return Icons.cleaning_services;
    case 'outdoor_grill':
      return Icons.outdoor_grill;
    case 'pets':
      return Icons.pets;
    case 'plumbing':
      return Icons.plumbing;
    case 'recycling':
      return Icons.recycling;
    case 'roofing':
      return Icons.roofing;
    case 'schedule':
      return Icons.schedule;
    case 'security':
      return Icons.security;
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'shower':
      return Icons.shower;
    case 'smoke_free':
      return Icons.smoke_free;
    case 'spa':
      return Icons.spa;
    case 'sprinkler':
      return Icons.water_drop;
    case 'thermostat':
      return Icons.thermostat;
    case 'vacuum':
      return Icons.cleaning_services;
    case 'wb_sunny':
      return Icons.wb_sunny;
    case 'weekend':
      return Icons.weekend;
    case 'cleaning_services':
      return Icons.cleaning_services;
    case 'local_florist':
      return Icons.local_florist;
    case 'water_drop':
      return Icons.water_drop;
    case 'kitchen':
      return Icons.kitchen;
    case 'grass':
      return Icons.grass;
    case 'home_repair_service':
      return Icons.home_repair_service;
    case defaultRecurringChoreIconKey:
    default:
      return Icons.event_repeat;
  }
}

Color recurringChoreColor(BuildContext context, String key) {
  switch (key) {
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'amber':
      return Colors.amber;
    case 'pink':
      return Colors.pink;
    case 'teal':
      return Colors.teal;
    case 'purple':
      return Colors.purple;
    case 'red':
      return Colors.red;
    case defaultRecurringChoreColorKey:
    default:
      return Theme.of(context).colorScheme.primary;
  }
}

String recurringChoreColorLabel(String key) {
  switch (key) {
    case 'green':
      return 'Green';
    case 'blue':
      return 'Blue';
    case 'amber':
      return 'Amber';
    case 'pink':
      return 'Pink';
    case 'teal':
      return 'Teal';
    case 'purple':
      return 'Purple';
    case 'red':
      return 'Red';
    case defaultRecurringChoreColorKey:
    default:
      return 'Default';
  }
}
