import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }
}