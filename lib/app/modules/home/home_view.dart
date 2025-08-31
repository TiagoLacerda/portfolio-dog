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
    final controls = Card(
      elevation: 8.0,
      color: ColorScheme.of(context).surfaceContainerHigh,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 32.0,
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

    final style = TextTheme.of(context).bodyMedium;
    final styleBold = style?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: style,
                    children: [
                      TextSpan(
                        text: 'The ',
                      ),
                      TextSpan(
                        text: 'Flow-Based Difference of Gaussians (FDoG)',
                        style: styleBold,
                      ),
                      TextSpan(
                        text:
                            ' is an image processing technique that enables a wide range of stylizations, including pencil, cross-hatching, watercolor, charcoal sketch, and stipple-brush effects.',
                      ),
                      TextSpan(
                        text: '\n\nProposed by ',
                      ),
                      TextSpan(
                        text: 'Holger Winnemöller and their team',
                        style: styleBold,
                      ),
                      TextSpan(
                        text:
                            ', it extends the traditional Difference of Gaussians (DoG) by approximating the structure tensor of the image using the Sobel operator, then guiding the filtering process so that blurring and edge enhancement occur along the natural flow of the image\'s features.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: controls,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              flex: 3,
              child: ValueListenableBuilder(
                valueListenable: isHovering,
                builder: (context, value, child) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      right: 32.0,
                    ),
                    physics: isHovering.value ? NeverScrollableScrollPhysics() : null,
                    child: child,
                  );
                },
                child: canvas,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
