import 'package:flutter/painting.dart' show Color;

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
    required this.numColors,
    required this.colors,
  });
}
