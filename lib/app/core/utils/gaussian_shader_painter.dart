import 'dart:math' hide log;
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

class GaussianShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final Image image;
  final int radius;
  final double sigma;
  final List<double> weights;

  static List<double> computeWeights(
    int radius,
    double sigma, [
    int maxRadius = 31,
  ]) {
    assert(radius <= maxRadius);

    final weights = List.filled(maxRadius + 1, 0.0);

    if (sigma == 0.0) {
      weights[0] = 1.0;
      return weights;
    }

    var sum = 0.0;

    final denominator = (2.0 * sigma * sigma);

    for (var i = 0; i <= radius; ++i) {
      weights[i] = exp(-(i * i) / denominator);

      sum += i == 0 ? weights[i] : weights[i] * 2.0;
    }

    for (var i = 0; i <= radius; ++i) {
      weights[i] /= sum;
    }

    return weights;
  }

  GaussianShaderPainter({
    required this.shader,
    required this.image,
    required this.radius,
    required this.sigma,
  }) : weights = computeWeights(radius, sigma);

  @override
  void paint(Canvas canvas, Size size) {
    final recorder = PictureRecorder();
    final intermediateCanvas = Canvas(recorder);

    Paint paint;

    // Horizontal pass

    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, radius.toDouble());
    shader.setFloat(3, 1.0);
    for (int i = 0; i < 32; ++i) {
      shader.setFloat(4 + i, weights[i]);
    }
    shader.setImageSampler(0, image);

    paint = Paint()..shader = shader;

    intermediateCanvas.drawRect(Offset.zero & size, paint);
    final intermediateImage = recorder.endRecording().toImageSync(
      size.width.toInt(),
      size.height.toInt(),
    );

    // Vertical pass

    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, radius.toDouble());
    shader.setFloat(3, 0.0);
    for (int i = 0; i < 32; ++i) {
      shader.setFloat(4 + i, weights[i]);
    }
    shader.setImageSampler(0, intermediateImage);

    paint = Paint()..shader = shader;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final old = (oldDelegate as GaussianShaderPainter);
    return !(old.radius == radius && old.sigma == sigma && old.image == image);
  }
}
