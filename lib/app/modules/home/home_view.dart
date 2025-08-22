import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/modules/home/home_controller.dart';
import 'package:flutter_shaders/app/modules/home/widgets/shader_controls.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;

  const HomeView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final minWidth = size.width;

    final (x1, y1, x2, y2) = (600.0, 20.0, 1920.0, 1920.0 * 0.25);
    final m = (y2 - y1) / (x2 - x1);
    f(double x) => (x - x1) * m + y1;

    final horizontal = max(y1, f(minWidth));

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            Card(
              elevation: 8.0,
              color: ColorScheme.of(context).surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                child: ShaderControls(
                  key: controller.shaderControls,
                  pipeline: controller.pipeline,
                ),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: ListenableBuilder(
                  listenable: controller.pipeline,
                  builder: (_, _) => SizedBox(
                    width: controller.pipeline.canvas.width.toDouble(),
                    height: controller.pipeline.canvas.height.toDouble(),
                    child: ColoredBox(
                      color: Colors.black,
                      child: InteractiveViewer(
                        minScale: 0.01,
                        maxScale: 100.0,
                        child: HtmlElementView(
                          viewType: 'webgl-canvas',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
