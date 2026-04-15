import 'package:flutter/material.dart';

class Utilities extends StatelessWidget {
  const Utilities({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static String formatMinutes(int? minutes, BuildContext context) {
    if (minutes == null) return '';

    final hour = minutes ~/ 60;
    final min = minutes % 60;

    final time = TimeOfDay(hour: hour, minute: min);
    return time.format(context); // respects device locale (AM/PM)
  }

  static int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  static TimeOfDay minutesToTimeOfDay(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  
}
