import 'package:flutter/painting.dart';

import 'enums/color_blending.dart';
import 'fdog_shader_settings.dart';

abstract final class FdogShaderPresets {
  static FDoGShaderSettings get baseline => FDoGShaderSettings(
    sigmaC: 0.0,
    sigmaCMin: 0.0,
    sigmaCMax: 10.0,
    sigmaE: 0.0,
    sigmaEMin: 0.0,
    sigmaEMax: 10.0,
    sigmaM: 0.0,
    sigmaMMin: 0.0,
    sigmaMMax: 10.0,
    sigmaA: 0.0,
    sigmaAMin: 0.0,
    sigmaAMax: 10.0,
    k: 1.0,
    kMin: 1.0,
    kMax: 10.0,
    tau: 0.0,
    tauMin: 0.0,
    tauMax: 100.0,
    epsilon: 1.0,
    epsilonMin: 0.0,
    epsilonMax: 1.0,
    phi: 1.0,
    phiMin: 0.0,
    phiMax: 10.0,
    scale: 1.0,
    scaleMin: 0.0,
    scaleMax: 1.0,
    useColorQuantization: false,
    useColorMapping: false,
    useColorBlending: false,
    colorBlending: ColorBlending.linear,
    usePaperTexture: false,
    numColors: 8,
    colors: const [
      Color(0xFF0E3738),
      Color(0xFF1B3F5D),
      Color(0xFF3B4479),
      Color(0xFF694A7E),
      Color(0xFF9C556E),
      Color(0xFFBF6A5C),
      Color(0xFFC78C56),
      Color(0xFFB5B96A),
    ],
  );

  static FDoGShaderSettings get pencil => baseline.copyWith(
    sigmaC: 0.1,
    sigmaE: 0.25,
    sigmaM: 0.5,
    sigmaA: 7.0,
    k: 8.0,
    tau: 30.0,
    epsilon: 0.75,
    phi: 1.75,
    scale: 2.0
  );

  static FDoGShaderSettings get charcoal => baseline.copyWith(
    sigmaC: 0.65,
    sigmaE: 3.77,
    sigmaM: 3.4,
    sigmaA: 0.7,
    k: 4.5,
    tau: 6.0,
    epsilon: 0.92,
    phi: 1.36,
  );

  static FDoGShaderSettings get woodblock => baseline.copyWith(
    sigmaC: 5.0,
    sigmaE: 1.75,
    sigmaM: 5.0,
    sigmaA: 1.25,
    k: 1.25,
    tau: 90.0,
    epsilon: 0.3,
    phi: 10.0,
  );

  static FDoGShaderSettings get watercolor => baseline.copyWith(
    sigmaC: 0.3,
    sigmaE: 0.1,
    sigmaM: 9.25,
    sigmaA: 8.75,
    k: 6.75,
    tau: 70.0,
    epsilon: 0.87,
    phi: 1.0,
    useColorBlending: true,
    colorBlending: ColorBlending.bicubic,
    usePaperTexture: true,
  );

  static FDoGShaderSettings get stippleBrush => baseline;

  static FDoGShaderSettings get crossHatching => baseline;
}
