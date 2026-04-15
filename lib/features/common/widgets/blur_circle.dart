import 'dart:ui';

import 'package:flutter/material.dart';

class BlurCircle extends StatelessWidget {
  final Color color;
  final double size;

  const BlurCircle({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return _blurCircle(color, size);
  }

  Widget _blurCircle(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}