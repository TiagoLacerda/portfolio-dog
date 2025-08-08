import 'dart:math' hide log;
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

class ShaderPainter extends CustomPainter {
  final FragmentShader blur;
  final FragmentShader dog;
  final Image image;
  final int radius;
  final double sigma;
  final double k;
  final List<double> weightsS;
  final List<double> weightsL;

  ShaderPainter({
    required this.blur,
    required this.dog,
    required this.image,
    required this.radius,
    required this.sigma,
    required this.k,
  }) : weightsS = computeWeights(radius, sigma * k),
       weightsL = computeWeights(radius, sigma);

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

  Image applyGaussianBlur(
    int radius,
    List<double> weights,
    Image image,
    Size size,
  ) {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    Image texture = image;
    Paint paint = Paint()..shader = blur;

    // Horizontal pass

    blur.setFloat(0, size.width);
    blur.setFloat(1, size.height);
    blur.setFloat(2, radius.toDouble());
    blur.setFloat(3, 1.0);
    for (int i = 0; i < 32; ++i) {
      blur.setFloat(4 + i, weights[i]);
    }
    blur.setImageSampler(0, image);

    paint = Paint()..shader = blur;

    canvas.drawRect(Offset.zero & size, paint);
    texture = recorder.endRecording().toImageSync(
      size.width.toInt(),
      size.height.toInt(),
    );

    // Vertical pass

    recorder = PictureRecorder();
    canvas = Canvas(recorder);

    blur.setFloat(0, size.width);
    blur.setFloat(1, size.height);
    blur.setFloat(2, radius.toDouble());
    blur.setFloat(3, 0.0);
    for (int i = 0; i < 32; ++i) {
      blur.setFloat(4 + i, weights[i]);
    }
    blur.setImageSampler(0, texture);

    paint = Paint()..shader = blur;

    canvas.drawRect(Offset.zero & size, paint);
    texture = recorder.endRecording().toImageSync(
      size.width.toInt(),
      size.height.toInt(),
    );

    return texture;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final small = applyGaussianBlur(radius, weightsS, image, size);
    final large = applyGaussianBlur(radius, weightsL, image, size);

    dog.setFloat(0, size.width);
    dog.setFloat(1, size.height);
    dog.setImageSampler(0, small);
    dog.setImageSampler(1, large);

    final paint = Paint()..shader = dog;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final old = (oldDelegate as ShaderPainter);
    return !(old.radius == radius && old.sigma == sigma && old.image == image);
  }
}
