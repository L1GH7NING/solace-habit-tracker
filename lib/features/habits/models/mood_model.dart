import 'package:flutter/material.dart';

class Mood {
  final int value;
  final String assetPath;
  final String label;
  final Color color;

  const Mood({
    required this.value,
    required this.assetPath,
    required this.label,
    required this.color,
  });
}

const moods = [
  Mood(
    value: 1,
    assetPath: 'assets/svgs/pouting-face.svg',
    label: 'Rough',
    color: Color(0xFFE24B4A),
  ),
  Mood(
    value: 2,
    assetPath: 'assets/svgs/disappointed-face.svg',
    label: 'Meh',
    color: Color(0xFFEF9F27),
  ),
  Mood(
    value: 3,
    assetPath: 'assets/svgs/neutral-face.svg',
    label: 'Okay',
    color: Color(0xFF378ADD),
  ),
  Mood(
    value: 4,
    assetPath: 'assets/svgs/smiling-face.svg',
    label: 'Good',
    color: Color(0xFF1D9E75),
  ),
  Mood(
    value: 5,
    assetPath: 'assets/svgs/smiling-face-with-heart-eyes.svg',
    label: 'Great',
    color: Color.fromARGB(255, 219, 99, 203),
  ),
];