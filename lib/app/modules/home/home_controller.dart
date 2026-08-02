import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import '../../core/adapters/webgl/fdog_shader_pipeline.dart';
import '../../core/utils/utils.dart';
import 'widgets/fdog_shader_presets.dart';
import 'widgets/fdog_shader_settings.dart';

class HomeController extends ChangeNotifier {
  final settings = FdogShaderPresets.preset;

  final pipeline = FDoGShaderPipeline();

  Image? image;

  @override
  void dispose() {
    image?.dispose();

    super.dispose();
  }

  Future<void> initialize() async {
    try {
      await pipeline.initialize();

      image = await Utils.loadImageFromAsset('images/samia.png');

      if (image == null) return;

      await pipeline.setImage(image!);

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

  Future<void> onChangeImage() async {
    image?.dispose();
    image = null;

    image = await Utils.pickImage();

    if (image == null) return;

    await pipeline.setImage(image!);

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

    notifyListeners();
  }

  /// Interpolates change from current to [newSettings]. Make sure to signal UI refreshes with [onChangedSettings].
  void animateToShaderSettings(FDoGShaderSettings newSettings, VoidCallback onChangedSettings) {
    final from = settings;
    final to = newSettings;

    const duration = Duration(milliseconds: 250);
    final start = DateTime.now();

    var oldSettings = settings;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final t = (DateTime.now().difference(start).inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

      settings.setFrom(from.lerp(to, t));

      onChangedSettings();

      if (settings.scale != oldSettings.scale) {
        pipeline.setScale(
          settings.scale,
        );
      }

      if (settings.useColorQuantization != oldSettings.useColorQuantization) {
        pipeline.useColorQuantization = settings.useColorQuantization;
      }

      if (settings.useColorMapping != oldSettings.useColorMapping) {
        pipeline.useColorMapping = settings.useColorMapping;
      }

      if (settings.useColorBlending != oldSettings.useColorBlending) {
        pipeline.useColorBlending = settings.useColorBlending;
      }

      if (settings.colors != oldSettings.colors) {
        pipeline.setColorMap(
          settings.colors,
        );
      }

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

      oldSettings = settings;

      if (t >= 1.0) {
        timer.cancel();
      }
    });
  }

  void onSetScale() => notifyListeners();
}
