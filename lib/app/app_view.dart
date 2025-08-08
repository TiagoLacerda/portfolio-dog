import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/app_controller.dart';
import 'package:flutter_shaders/app/core/theme/app_theme.dart';
import 'package:flutter_shaders/app/core/utils/gaussian_shader_painter.dart';

class AppView extends StatefulWidget {
  final AppController controller;

  const AppView({super.key, required this.controller});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  var _radius = 0;
  var _sigma = 4.0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, _) => MaterialApp(
        title: 'Flutter Shaders',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: widget.controller.loadImage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image_search_outlined),
                      const SizedBox(width: 16.0),
                      Text('Load image'),
                    ],
                  ),
                ),
                if (widget.controller.image == null) ...[
                  Text(
                    'No image currently loaded...',
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Row(
                    children: [
                      Text(_radius.toStringAsFixed(2)),
                      Slider(
                        value: _radius.toDouble(),
                        min: 0,
                        max: 31,
                        divisions: 31,
                        onChanged: (value) =>
                            setState(() => _radius = value.toInt()),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_sigma.toStringAsFixed(2)),
                      Slider(
                        value: _sigma,
                        min: 0.0,
                        max: 31.0,
                        onChanged: (value) => setState(() => _sigma = value),
                      ),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomPaint(
                      size: Size(
                        widget.controller.image!.width.toDouble(),
                        widget.controller.image!.height.toDouble(),
                      ),
                      painter: GaussianShaderPainter(
                        shader: widget.controller.program!.fragmentShader(),
                        image: widget.controller.image!,
                        radius: _radius,
                        sigma: _sigma,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
