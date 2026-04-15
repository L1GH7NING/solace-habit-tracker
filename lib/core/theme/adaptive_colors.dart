import 'package:flutter/material.dart';

class AdaptiveColors {
  static Color accent(BuildContext context, Color base) {
    final brightness = Theme.of(context).brightness;

    if (brightness == Brightness.dark) {
      final hsl = HSLColor.fromColor(base);

      return hsl
          .withSaturation((hsl.saturation * 0.8).clamp(0.0, 1.0))
          .withLightness((hsl.lightness * 0.9).clamp(0.0, 1.0))
          .toColor();
    }

    return base;
  }
}