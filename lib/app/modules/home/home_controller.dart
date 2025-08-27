import 'dart:developer';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/core/utils/utils.dart';
import 'package:flutter_shaders/app/modules/home/my_shader_pipeline.dart';
import 'package:flutter_shaders/app/modules/home/widgets/shader_controls.dart';

class HomeController extends ChangeNotifier {
  final pipeline = MyShaderPipeline();
  final shaderControls = GlobalKey<ShaderControlsState>();

  @override
  dispose() {
    pipeline.dispose();

    super.dispose();
  }

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

      pipeline.setColorMap(colors);
      pipeline.setColorBlending(state.useColorBlending);
      pipeline.setScale(state.scale);

      shaderControls.currentState!.draw();

      pipeline.notifyListeners();
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
