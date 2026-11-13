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

  bool useColorQuantization;
  bool useColorMapping;
  bool useColorBlending;
  bool usePaperTexture;

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
    required this.useColorQuantization,
    required this.useColorMapping,
    required this.useColorBlending,
    required this.colorBlending,
    required this.usePaperTexture,
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
    bool? useColorQuantization,
    bool? useColorMapping,
    bool? useColorBlending,
    ColorBlending? colorBlending,
    bool? usePaperTexture,
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
      useColorQuantization: useColorQuantization ?? this.useColorQuantization,
      useColorMapping: useColorMapping ?? this.useColorMapping,
      useColorBlending: useColorBlending ?? this.useColorBlending,
      colorBlending: colorBlending ?? this.colorBlending,
      usePaperTexture: usePaperTexture ?? this.usePaperTexture,
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
      useColorQuantization: t < 0.5 ? useColorQuantization : other.useColorQuantization,
      useColorMapping: t < 0.5 ? useColorMapping : other.useColorMapping,
      useColorBlending: t < 0.5 ? useColorBlending : other.useColorBlending,
      colorBlending: t < 0.5 ? colorBlending : other.colorBlending,
      usePaperTexture: t < 0.5 ? usePaperTexture : other.usePaperTexture,
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
    useColorQuantization = other.useColorQuantization;
    useColorMapping = other.useColorMapping;
    useColorBlending = other.useColorBlending;
    colorBlending = other.colorBlending;
    usePaperTexture = other.usePaperTexture;
    numColors = other.numColors;
    colors = other.colors;
  }
}
