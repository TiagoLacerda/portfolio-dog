import 'dart:developer';

import 'package:flutter/material.dart' hide Image;

import '../../core/adapters/webgl/fdog_shader_pipeline.dart';
import '../../core/utils/utils.dart';
import 'widgets/fdog_shader_settings.dart';

class HomeController extends ChangeNotifier {
  final settings = FDoGShaderSettings(
    sigmaC: 0.075,
    sigmaCMin: 0.0,
    sigmaCMax: 10.0,
    sigmaE: 0.5,
    sigmaEMin: 0.0,
    sigmaEMax: 10.0,
    sigmaM: 10.0,
    sigmaMMin: 0.0,
    sigmaMMax: 10.0,
    sigmaA: 4.8,
    sigmaAMin: 0.0,
    sigmaAMax: 10.0,
    k: 1.6,
    kMin: 1.0,
    kMax: 10.0,
    tau: 100.0,
    tauMin: 0.0,
    tauMax: 100.0,
    epsilon: 0.3,
    epsilonMin: 0.0,
    epsilonMax: 1.0,
    phi: 0.9,
    phiMin: 0.0,
    phiMax: 10.0,
    scale: 0.347,
    scaleMin: 0.0,
    scaleMax: 1.0,
    useColorQuantization: true,
    useColorMapping: true,
    useColorBlending: true,
    numColors: 8,
    colors: [
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

  final pipeline = FDoGShaderPipeline();

  Future<void> initialize() async {
    try {
      await pipeline.initialize();

      final image = await Utils.loadImageFromAsset('images/samia.png');

      if (image == null) return;

      await pipeline.setImage(image);

      final colors = settings.useColorMapping ? settings.colors : <Color>[];

      pipeline.useColorQuantization = settings.useColorQuantization;
      pipeline.useColorMapping = settings.useColorMapping;
      pipeline.useColorBlending = settings.useColorBlending;
      pipeline.setColorMap(colors);
      pipeline.setScale(settings.scale);
      pipeline.draw(
        settings.sigmaC,
        settings.sigmaE,
        settings.sigmaM,
        settings.sigmaA,
        settings.k,
        settings.tau,
        settings.epsilon,
        settings.phi,
        settings.numColors,
      );
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void onSetScale() => notifyListeners();
}
