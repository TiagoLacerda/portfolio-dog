import 'dart:math';

import 'package:material_ui/material_ui.dart';

class Oklab {
  final double l;
  final double a;
  final double b;

  const Oklab(
    this.l,
    this.a,
    this.b,
  );

  static Color lab2srgb(
    double l,
    double a,
    double b,
  ) {
    // Convert Oklab → LMS
    final L = l + 0.3963377774 * a + 0.2158037573 * b;
    final M = l - 0.1055613458 * a - 0.0638541728 * b;
    final S = l - 0.0894841775 * a - 1.2914855480 * b;

    final l_ = L * L * L;
    final m_ = M * M * M;
    final s_ = S * S * S;

    // Convert LMS → linear sRGB
    final rLin = 4.0767416621 * l_ - 3.3077115913 * m_ + 0.2309699292 * s_;
    final gLin = -1.2684380046 * l_ + 2.6097574011 * m_ - 0.3413193965 * s_;
    final bLin = -0.0041960863 * l_ - 0.7034186147 * m_ + 1.7076147010 * s_;

    // Linear → sRGB gamma
    double toSrgb(double x) {
      x = x.clamp(0.0, 1.0);
      if (x <= 0.0031308) return 12.92 * x;
      return 1.055 * pow(x, 1.0 / 2.4) - 0.055;
    }

    int toInt(double x) => (toSrgb(x) * 255).round().clamp(0, 255);

    return Color.fromARGB(
      255,
      toInt(rLin),
      toInt(gLin),
      toInt(bLin),
    );
  }
}
