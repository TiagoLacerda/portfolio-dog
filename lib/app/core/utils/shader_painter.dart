import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final Image image;
  final double r;
  final double g;
  final double b;

  ShaderPainter({
    required this.shader,
    required this.image,
    this.r = 1.0,
    this.g = 1.0,
    this.b = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, r);
    shader.setFloat(1, g);
    shader.setFloat(2, b);
    shader.setFloat(3, size.width);
    shader.setFloat(4, size.height);
    shader.setImageSampler(0, image);

    final paint = Paint()..shader = shader;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
