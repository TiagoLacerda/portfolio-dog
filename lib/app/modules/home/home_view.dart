import 'dart:math' hide log;

import 'package:flutter/material.dart';

import 'home_controller.dart';
import 'widgets/shader_controls.dart';

class HomeView extends StatefulWidget {
  final HomeController controller;

  const HomeView({
    super.key,
    required this.controller,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();

  final isHovering = ValueNotifier<bool>(false);

  @override
  void dispose() {
    scrollController.dispose();
    isHovering.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final minWidth = size.width;

    final (x1, y1, x2, y2) = (600.0, 20.0, 1920.0, 1920.0 * 0.25);
    final m = (y2 - y1) / (x2 - x1);
    f(double x) => (x - x1) * m + y1;

    final horizontal = max(y1, f(minWidth));

    final controls = Card(
      elevation: 8.0,
      color: ColorScheme.of(context).surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 16.0,
        ),
        child: ShaderControls(
          key: widget.controller.shaderControls,
          pipeline: widget.controller.pipeline,
        ),
      ),
    );

    final canvas = ListenableBuilder(
      listenable: widget.controller.pipeline,
      builder: (_, _) {
        final width = widget.controller.pipeline.canvas.width.toDouble();
        final height = widget.controller.pipeline.canvas.height.toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MouseRegion(
              onEnter: (_) => isHovering.value = true,
              onExit: (_) => isHovering.value = false,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: width,
                  height: height,
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
            Align(
              alignment: Alignment.centerRight,
              child: Text('${width}x$height'),
            ),
          ],
        );
      },
    );

    if (size.width > size.height) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: horizontal / 2.0,
                  right: 8.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: controls,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: isHovering,
                builder: (context, value, child) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    physics: isHovering.value ? NeverScrollableScrollPhysics() : null,
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: horizontal / 2.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    child: child,
                  );
                },
                child: canvas,
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: ValueListenableBuilder<bool>(
          valueListenable: isHovering,
          builder: (context, value, child) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: isHovering.value ? NeverScrollableScrollPhysics() : null,
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: horizontal,
              ),
              child: child,
            );
          },
          child: Column(
            children: [
              controls,
              SizedBox(height: 16.0),
              canvas,
            ],
          ),
        ),
      );
    }
  }
}
