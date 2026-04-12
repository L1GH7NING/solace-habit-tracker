import 'dart:ui';

class HabitUIModel {
  final String name;
  final String icon;
  final Color color;
  final int current;
  final int target;
  final String time;

  HabitUIModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.current,
    required this.target,
    required this.time,
  });
}