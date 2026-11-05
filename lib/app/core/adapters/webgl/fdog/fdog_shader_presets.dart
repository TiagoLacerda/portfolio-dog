import 'package:flutter/painting.dart';

import 'fdog_shader_settings.dart';

abstract final class FdogShaderPresets {
  static FDoGShaderSettings get preset => FDoGShaderSettings(
    sigmaC: 4.0,
    sigmaCMin: 0.0,
    sigmaCMax: 10.0,
    sigmaE: 7.0,
    sigmaEMin: 0.0,
    sigmaEMax: 10.0,
    sigmaM: 5.0,
    sigmaMMin: 0.0,
    sigmaMMax: 10.0,
    sigmaA: 3.0,
    sigmaAMin: 0.0,
    sigmaAMax: 10.0,
    k: 1.5,
    kMin: 1.0,
    kMax: 10.0,
    tau: 6.0,
    tauMin: 0.0,
    tauMax: 10.0,
    epsilon: 0.65,
    epsilonMin: 0.0,
    epsilonMax: 1.0,
    phi: 2.35,
    phiMin: 0.0,
    phiMax: 10.0,
    scale: 1.0,
    scaleMin: 0.0,
    scaleMax: 1.0,
    useColorQuantization: false,
    useColorMapping: false,
    useColorBlending: true,
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
}
