import 'package:flutter/painting.dart' show Color;

import 'enums/color_blending.dart';

class FDoGShaderSettings {
  double sigmaC;
  double sigmaCMin;
  double sigmaCMax;

  double sigmaE;
  double sigmaEMin;
  double sigmaEMax;

  double sigmaM;
  double sigmaMMin;
  double sigmaMMax;

  double sigmaA;
  double sigmaAMin;
  double sigmaAMax;

  double k;
  double kMin;
  double kMax;

  double tau;
  double tauMin;
  double tauMax;

  double epsilon;
  double epsilonMin;
  double epsilonMax;

  double phi;
  double phiMin;
  double phiMax;

  double scale;
  double scaleMin;
  double scaleMax;

  double crossHatchingAngle1;
  double crossHatchingAngle1Min;
  double crossHatchingAngle1Max;

  double crossHatchingThreshold1;
  double crossHatchingThreshold1Min;
  double crossHatchingThreshold1Max;

  double crossHatchingAngle2;
  double crossHatchingAngle2Min;
  double crossHatchingAngle2Max;

  double crossHatchingThreshold2;
  double crossHatchingThreshold2Min;
  double crossHatchingThreshold2Max;

  double crossHatchingAngle3;
  double crossHatchingAngle3Min;
  double crossHatchingAngle3Max;

  double crossHatchingThreshold3;
  double crossHatchingThreshold3Min;
  double crossHatchingThreshold3Max;

  double crossHatchingAngle4;
  double crossHatchingAngle4Min;
  double crossHatchingAngle4Max;

  double crossHatchingThreshold4;
  double crossHatchingThreshold4Min;
  double crossHatchingThreshold4Max;

  double crossHatchingScale;
  double crossHatchingScaleMin;
  double crossHatchingScaleMax;

  bool useColorQuantization;
  bool useColorMapping;
  bool useColorBlending;
  bool usePaperTexture;
  bool useCrossHatching;

  ColorBlending colorBlending;

  int numColors;

  List<Color> colors;

  FDoGShaderSettings({
    required this.sigmaC,
    required this.sigmaCMin,
    required this.sigmaCMax,
    required this.sigmaE,
    required this.sigmaEMin,
    required this.sigmaEMax,
    required this.sigmaM,
    required this.sigmaMMin,
    required this.sigmaMMax,
    required this.sigmaA,
    required this.sigmaAMin,
    required this.sigmaAMax,
    required this.k,
    required this.kMin,
    required this.kMax,
    required this.tau,
    required this.tauMin,
    required this.tauMax,
    required this.epsilon,
    required this.epsilonMin,
    required this.epsilonMax,
    required this.phi,
    required this.phiMin,
    required this.phiMax,
    required this.scale,
    required this.scaleMin,
    required this.scaleMax,
    required this.crossHatchingAngle1,
    required this.crossHatchingAngle1Min,
    required this.crossHatchingAngle1Max,
    required this.crossHatchingThreshold1,
    required this.crossHatchingThreshold1Min,
    required this.crossHatchingThreshold1Max,
    required this.crossHatchingAngle2,
    required this.crossHatchingAngle2Min,
    required this.crossHatchingAngle2Max,
    required this.crossHatchingThreshold2,
    required this.crossHatchingThreshold2Min,
    required this.crossHatchingThreshold2Max,
    required this.crossHatchingAngle3,
    required this.crossHatchingAngle3Min,
    required this.crossHatchingAngle3Max,
    required this.crossHatchingThreshold3,
    required this.crossHatchingThreshold3Min,
    required this.crossHatchingThreshold3Max,
    required this.crossHatchingAngle4,
    required this.crossHatchingAngle4Min,
    required this.crossHatchingAngle4Max,
    required this.crossHatchingThreshold4,
    required this.crossHatchingThreshold4Min,
    required this.crossHatchingThreshold4Max,
    required this.crossHatchingScale,
    required this.crossHatchingScaleMin,
    required this.crossHatchingScaleMax,
    required this.useColorQuantization,
    required this.useColorMapping,
    required this.useColorBlending,
    required this.colorBlending,
    required this.usePaperTexture,
    required this.useCrossHatching,
    required this.numColors,
    required this.colors,
  });

  FDoGShaderSettings copyWith({
    double? sigmaC,
    double? sigmaCMin,
    double? sigmaCMax,
    double? sigmaE,
    double? sigmaEMin,
    double? sigmaEMax,
    double? sigmaM,
    double? sigmaMMin,
    double? sigmaMMax,
    double? sigmaA,
    double? sigmaAMin,
    double? sigmaAMax,
    double? k,
    double? kMin,
    double? kMax,
    double? tau,
    double? tauMin,
    double? tauMax,
    double? epsilon,
    double? epsilonMin,
    double? epsilonMax,
    double? phi,
    double? phiMin,
    double? phiMax,
    double? scale,
    double? scaleMin,
    double? scaleMax,
    double? crossHatchingAngle1,
    double? crossHatchingAngle1Min,
    double? crossHatchingAngle1Max,
    double? crossHatchingThreshold1,
    double? crossHatchingThreshold1Min,
    double? crossHatchingThreshold1Max,
    double? crossHatchingAngle2,
    double? crossHatchingAngle2Min,
    double? crossHatchingAngle2Max,
    double? crossHatchingThreshold2,
    double? crossHatchingThreshold2Min,
    double? crossHatchingThreshold2Max,
    double? crossHatchingAngle3,
    double? crossHatchingAngle3Min,
    double? crossHatchingAngle3Max,
    double? crossHatchingThreshold3,
    double? crossHatchingThreshold3Min,
    double? crossHatchingThreshold3Max,
    double? crossHatchingAngle4,
    double? crossHatchingAngle4Min,
    double? crossHatchingAngle4Max,
    double? crossHatchingThreshold4,
    double? crossHatchingThreshold4Min,
    double? crossHatchingThreshold4Max,
    double? crossHatchingScale,
    double? crossHatchingScaleMin,
    double? crossHatchingScaleMax,
    bool? useColorQuantization,
    bool? useColorMapping,
    bool? useColorBlending,
    ColorBlending? colorBlending,
    bool? usePaperTexture,
    bool? useCrossHatching,
    int? numColors,
    List<Color>? colors,
  }) {
    return FDoGShaderSettings(
      sigmaC: sigmaC ?? this.sigmaC,
      sigmaCMin: sigmaCMin ?? this.sigmaCMin,
      sigmaCMax: sigmaCMax ?? this.sigmaCMax,
      sigmaE: sigmaE ?? this.sigmaE,
      sigmaEMin: sigmaEMin ?? this.sigmaEMin,
      sigmaEMax: sigmaEMax ?? this.sigmaEMax,
      sigmaM: sigmaM ?? this.sigmaM,
      sigmaMMin: sigmaMMin ?? this.sigmaMMin,
      sigmaMMax: sigmaMMax ?? this.sigmaMMax,
      sigmaA: sigmaA ?? this.sigmaA,
      sigmaAMin: sigmaAMin ?? this.sigmaAMin,
      sigmaAMax: sigmaAMax ?? this.sigmaAMax,
      k: k ?? this.k,
      kMin: kMin ?? this.kMin,
      kMax: kMax ?? this.kMax,
      tau: tau ?? this.tau,
      tauMin: tauMin ?? this.tauMin,
      tauMax: tauMax ?? this.tauMax,
      epsilon: epsilon ?? this.epsilon,
      epsilonMin: epsilonMin ?? this.epsilonMin,
      epsilonMax: epsilonMax ?? this.epsilonMax,
      phi: phi ?? this.phi,
      phiMin: phiMin ?? this.phiMin,
      phiMax: phiMax ?? this.phiMax,
      scale: scale ?? this.scale,
      scaleMin: scaleMin ?? this.scaleMin,
      scaleMax: scaleMax ?? this.scaleMax,
      crossHatchingAngle1: crossHatchingAngle1 ?? this.crossHatchingAngle1,
      crossHatchingAngle1Min: crossHatchingAngle1Min ?? this.crossHatchingAngle1Min,
      crossHatchingAngle1Max: crossHatchingAngle1Max ?? this.crossHatchingAngle1Max,
      crossHatchingThreshold1: crossHatchingThreshold1 ?? this.crossHatchingThreshold1,
      crossHatchingThreshold1Min: crossHatchingThreshold1Min ?? this.crossHatchingThreshold1Min,
      crossHatchingThreshold1Max: crossHatchingThreshold1Max ?? this.crossHatchingThreshold1Max,
      crossHatchingAngle2: crossHatchingAngle2 ?? this.crossHatchingAngle2,
      crossHatchingAngle2Min: crossHatchingAngle2Min ?? this.crossHatchingAngle2Min,
      crossHatchingAngle2Max: crossHatchingAngle2Max ?? this.crossHatchingAngle2Max,
      crossHatchingThreshold2: crossHatchingThreshold2 ?? this.crossHatchingThreshold2,
      crossHatchingThreshold2Min: crossHatchingThreshold2Min ?? this.crossHatchingThreshold2Min,
      crossHatchingThreshold2Max: crossHatchingThreshold2Max ?? this.crossHatchingThreshold2Max,
      crossHatchingAngle3: crossHatchingAngle3 ?? this.crossHatchingAngle3,
      crossHatchingAngle3Min: crossHatchingAngle3Min ?? this.crossHatchingAngle3Min,
      crossHatchingAngle3Max: crossHatchingAngle3Max ?? this.crossHatchingAngle3Max,
      crossHatchingThreshold3: crossHatchingThreshold3 ?? this.crossHatchingThreshold3,
      crossHatchingThreshold3Min: crossHatchingThreshold3Min ?? this.crossHatchingThreshold3Min,
      crossHatchingThreshold3Max: crossHatchingThreshold3Max ?? this.crossHatchingThreshold3Max,
      crossHatchingAngle4: crossHatchingAngle4 ?? this.crossHatchingAngle4,
      crossHatchingAngle4Min: crossHatchingAngle4Min ?? this.crossHatchingAngle4Min,
      crossHatchingAngle4Max: crossHatchingAngle4Max ?? this.crossHatchingAngle4Max,
      crossHatchingThreshold4: crossHatchingThreshold4 ?? this.crossHatchingThreshold4,
      crossHatchingThreshold4Min: crossHatchingThreshold4Min ?? this.crossHatchingThreshold4Min,
      crossHatchingThreshold4Max: crossHatchingThreshold4Max ?? this.crossHatchingThreshold4Max,
      crossHatchingScale: crossHatchingScale ?? this.crossHatchingScale,
      crossHatchingScaleMin: crossHatchingScaleMin ?? this.crossHatchingScaleMin,
      crossHatchingScaleMax: crossHatchingScaleMax ?? this.crossHatchingScaleMax,
      useColorQuantization: useColorQuantization ?? this.useColorQuantization,
      useColorMapping: useColorMapping ?? this.useColorMapping,
      useColorBlending: useColorBlending ?? this.useColorBlending,
      colorBlending: colorBlending ?? this.colorBlending,
      usePaperTexture: usePaperTexture ?? this.usePaperTexture,
      useCrossHatching: useCrossHatching ?? this.useCrossHatching,
      numColors: numColors ?? this.numColors,
      colors: colors ?? this.colors,
    );
  }

  FDoGShaderSettings lerp(FDoGShaderSettings other, double t) {
    double lerpDouble(double a, double b) => a + (b - a) * t;

    return FDoGShaderSettings(
      sigmaC: lerpDouble(sigmaC, other.sigmaC),
      sigmaCMin: lerpDouble(sigmaCMin, other.sigmaCMin),
      sigmaCMax: lerpDouble(sigmaCMax, other.sigmaCMax),
      sigmaE: lerpDouble(sigmaE, other.sigmaE),
      sigmaEMin: lerpDouble(sigmaEMin, other.sigmaEMin),
      sigmaEMax: lerpDouble(sigmaEMax, other.sigmaEMax),
      sigmaM: lerpDouble(sigmaM, other.sigmaM),
      sigmaMMin: lerpDouble(sigmaMMin, other.sigmaMMin),
      sigmaMMax: lerpDouble(sigmaMMax, other.sigmaMMax),
      sigmaA: lerpDouble(sigmaA, other.sigmaA),
      sigmaAMin: lerpDouble(sigmaAMin, other.sigmaAMin),
      sigmaAMax: lerpDouble(sigmaAMax, other.sigmaAMax),
      k: lerpDouble(k, other.k),
      kMin: lerpDouble(kMin, other.kMin),
      kMax: lerpDouble(kMax, other.kMax),
      tau: lerpDouble(tau, other.tau),
      tauMin: lerpDouble(tauMin, other.tauMin),
      tauMax: lerpDouble(tauMax, other.tauMax),
      epsilon: lerpDouble(epsilon, other.epsilon),
      epsilonMin: lerpDouble(epsilonMin, other.epsilonMin),
      epsilonMax: lerpDouble(epsilonMax, other.epsilonMax),
      phi: lerpDouble(phi, other.phi),
      phiMin: lerpDouble(phiMin, other.phiMin),
      phiMax: lerpDouble(phiMax, other.phiMax),
      scale: lerpDouble(scale, other.scale),
      scaleMin: lerpDouble(scaleMin, other.scaleMin),
      scaleMax: lerpDouble(scaleMax, other.scaleMax),
      crossHatchingAngle1: lerpDouble(
        crossHatchingAngle1,
        other.crossHatchingAngle1,
      ),
      crossHatchingAngle1Min: lerpDouble(
        crossHatchingAngle1Min,
        other.crossHatchingAngle1Min,
      ),
      crossHatchingAngle1Max: lerpDouble(
        crossHatchingAngle1Max,
        other.crossHatchingAngle1Max,
      ),
      crossHatchingThreshold1: lerpDouble(
        crossHatchingThreshold1,
        other.crossHatchingThreshold1,
      ),
      crossHatchingThreshold1Min: lerpDouble(
        crossHatchingThreshold1Min,
        other.crossHatchingThreshold1Min,
      ),
      crossHatchingThreshold1Max: lerpDouble(
        crossHatchingThreshold1Max,
        other.crossHatchingThreshold1Max,
      ),
      crossHatchingAngle2: lerpDouble(
        crossHatchingAngle2,
        other.crossHatchingAngle2,
      ),
      crossHatchingAngle2Min: lerpDouble(
        crossHatchingAngle2Min,
        other.crossHatchingAngle2Min,
      ),
      crossHatchingAngle2Max: lerpDouble(
        crossHatchingAngle2Max,
        other.crossHatchingAngle2Max,
      ),
      crossHatchingThreshold2: lerpDouble(
        crossHatchingThreshold2,
        other.crossHatchingThreshold2,
      ),
      crossHatchingThreshold2Min: lerpDouble(
        crossHatchingThreshold2Min,
        other.crossHatchingThreshold2Min,
      ),
      crossHatchingThreshold2Max: lerpDouble(
        crossHatchingThreshold2Max,
        other.crossHatchingThreshold2Max,
      ),
      crossHatchingAngle3: lerpDouble(
        crossHatchingAngle3,
        other.crossHatchingAngle3,
      ),
      crossHatchingAngle3Min: lerpDouble(
        crossHatchingAngle3Min,
        other.crossHatchingAngle3Min,
      ),
      crossHatchingAngle3Max: lerpDouble(
        crossHatchingAngle3Max,
        other.crossHatchingAngle3Max,
      ),
      crossHatchingThreshold3: lerpDouble(
        crossHatchingThreshold3,
        other.crossHatchingThreshold3,
      ),
      crossHatchingThreshold3Min: lerpDouble(
        crossHatchingThreshold3Min,
        other.crossHatchingThreshold3Min,
      ),
      crossHatchingThreshold3Max: lerpDouble(
        crossHatchingThreshold3Max,
        other.crossHatchingThreshold3Max,
      ),
      crossHatchingAngle4: lerpDouble(
        crossHatchingAngle4,
        other.crossHatchingAngle4,
      ),
      crossHatchingAngle4Min: lerpDouble(
        crossHatchingAngle4Min,
        other.crossHatchingAngle4Min,
      ),
      crossHatchingAngle4Max: lerpDouble(
        crossHatchingAngle4Max,
        other.crossHatchingAngle4Max,
      ),
      crossHatchingThreshold4: lerpDouble(
        crossHatchingThreshold4,
        other.crossHatchingThreshold4,
      ),
      crossHatchingThreshold4Min: lerpDouble(
        crossHatchingThreshold4Min,
        other.crossHatchingThreshold4Min,
      ),
      crossHatchingThreshold4Max: lerpDouble(
        crossHatchingThreshold4Max,
        other.crossHatchingThreshold4Max,
      ),
      crossHatchingScale: lerpDouble(
        crossHatchingScale,
        other.crossHatchingScale,
      ),
      crossHatchingScaleMin: lerpDouble(
        crossHatchingScaleMin,
        other.crossHatchingScaleMin,
      ),
      crossHatchingScaleMax: lerpDouble(
        crossHatchingScaleMax,
        other.crossHatchingScaleMax,
      ),
      useColorQuantization: t < 0.5 ? useColorQuantization : other.useColorQuantization,
      useColorMapping: t < 0.5 ? useColorMapping : other.useColorMapping,
      useColorBlending: t < 0.5 ? useColorBlending : other.useColorBlending,
      colorBlending: t < 0.5 ? colorBlending : other.colorBlending,
      usePaperTexture: t < 0.5 ? usePaperTexture : other.usePaperTexture,
      useCrossHatching: t < 0.5 ? useCrossHatching : other.useCrossHatching,
      numColors: t < 0.5 ? numColors : other.numColors,
      colors: t < 0.5 ? colors : other.colors,
    );
  }

  void setFrom(FDoGShaderSettings other) {
    sigmaC = other.sigmaC;
    sigmaCMin = other.sigmaCMin;
    sigmaCMax = other.sigmaCMax;
    sigmaE = other.sigmaE;
    sigmaEMin = other.sigmaEMin;
    sigmaEMax = other.sigmaEMax;
    sigmaM = other.sigmaM;
    sigmaMMin = other.sigmaMMin;
    sigmaMMax = other.sigmaMMax;
    sigmaA = other.sigmaA;
    sigmaAMin = other.sigmaAMin;
    sigmaAMax = other.sigmaAMax;
    k = other.k;
    kMin = other.kMin;
    kMax = other.kMax;
    tau = other.tau;
    tauMin = other.tauMin;
    tauMax = other.tauMax;
    epsilon = other.epsilon;
    epsilonMin = other.epsilonMin;
    epsilonMax = other.epsilonMax;
    phi = other.phi;
    phiMin = other.phiMin;
    phiMax = other.phiMax;
    scale = other.scale;
    scaleMin = other.scaleMin;
    scaleMax = other.scaleMax;
    crossHatchingAngle1 = other.crossHatchingAngle1;
    crossHatchingAngle1Min = other.crossHatchingAngle1Min;
    crossHatchingAngle1Max = other.crossHatchingAngle1Max;
    crossHatchingThreshold1 = other.crossHatchingThreshold1;
    crossHatchingThreshold1Min = other.crossHatchingThreshold1Min;
    crossHatchingThreshold1Max = other.crossHatchingThreshold1Max;
    crossHatchingAngle2 = other.crossHatchingAngle2;
    crossHatchingAngle2Min = other.crossHatchingAngle2Min;
    crossHatchingAngle2Max = other.crossHatchingAngle2Max;
    crossHatchingThreshold2 = other.crossHatchingThreshold2;
    crossHatchingThreshold2Min = other.crossHatchingThreshold2Min;
    crossHatchingThreshold2Max = other.crossHatchingThreshold2Max;
    crossHatchingAngle3 = other.crossHatchingAngle3;
    crossHatchingAngle3Min = other.crossHatchingAngle3Min;
    crossHatchingAngle3Max = other.crossHatchingAngle3Max;
    crossHatchingThreshold3 = other.crossHatchingThreshold3;
    crossHatchingThreshold3Min = other.crossHatchingThreshold3Min;
    crossHatchingThreshold3Max = other.crossHatchingThreshold3Max;
    crossHatchingAngle4 = other.crossHatchingAngle4;
    crossHatchingAngle4Min = other.crossHatchingAngle4Min;
    crossHatchingAngle4Max = other.crossHatchingAngle4Max;
    crossHatchingThreshold4 = other.crossHatchingThreshold4;
    crossHatchingThreshold4Min = other.crossHatchingThreshold4Min;
    crossHatchingThreshold4Max = other.crossHatchingThreshold4Max;
    crossHatchingScale = other.crossHatchingScale;
    crossHatchingScaleMin = other.crossHatchingScaleMin;
    crossHatchingScaleMax = other.crossHatchingScaleMax;
    useColorQuantization = other.useColorQuantization;
    useColorMapping = other.useColorMapping;
    useColorBlending = other.useColorBlending;
    colorBlending = other.colorBlending;
    usePaperTexture = other.usePaperTexture;
    useCrossHatching = other.useCrossHatching;
    numColors = other.numColors;
    colors = other.colors;
  }
}
