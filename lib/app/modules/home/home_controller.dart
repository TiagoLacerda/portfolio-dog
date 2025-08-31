import 'dart:developer';

import 'package:flutter/material.dart' hide Image;

import '../../core/adapters/webgl/fdog_shader_pipeline.dart';
import '../../core/utils/utils.dart';
import 'widgets/shader_controls.dart';

class HomeController extends ChangeNotifier {
  final pipeline = FDoGShaderPipeline();
  final shaderControls = GlobalKey<ShaderControlsState>();

  HomeController() {
    initialize();
  }

  Future<void> initialize() async {
    try {
      await pipeline.initialize();

      final image = await Utils.loadImageFromAsset('images/samia.png');

      if (image == null) return;

      await pipeline.setImage(image);

      final state = shaderControls.currentState!;
      final colors = state.useColorMapping ? state.colors : <Color>[];

      pipeline.useColorQuantization = state.useColorQuantization;
      pipeline.useColorMapping = state.useColorMapping;
      pipeline.useColorBlending = state.useColorBlending;
      pipeline.setColorMap(colors);
      pipeline.setScale(state.scale);

      shaderControls.currentState!.draw();
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void onSetScale() => notifyListeners();
}
