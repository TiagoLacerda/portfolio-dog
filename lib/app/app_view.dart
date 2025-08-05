import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/app_controller.dart';
import 'package:flutter_shaders/app/core/theme/app_theme.dart';
import 'package:flutter_shaders/app/core/utils/shader_painter.dart';

class AppView extends StatefulWidget {
  final AppController controller;

  const AppView({super.key, required this.controller});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  double r = 0.0;
  double g = 0.0;
  double b = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, _) => MaterialApp(
        title: 'Flutter Shaders',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'r: $r',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: r,
                        onChanged: (value) => setState(() => r = value),
                        activeColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'g: $g',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: g,
                        onChanged: (value) => setState(() => g = value),
                        activeColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'b: $b',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: b,
                        onChanged: (value) => setState(() => b = value),
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: widget.controller.loadImage,
                  child: Text(
                    'Load image',
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.controller.loadShader,
                  child: Text(
                    'Load shader',
                  ),
                ),
                if (widget.controller.image == null) ...[
                  Text(
                    'No image currently loaded...',
                    textAlign: TextAlign.center,
                  ),
                ],
                if (widget.controller.program == null) ...[
                  Text(
                    'No shader program loaded...',
                    textAlign: TextAlign.center,
                  ),
                ],
                if (widget.controller.image != null &&
                    widget.controller.program != null) ...[
                  CustomPaint(
                    size: Size(800, 600),
                    painter: ShaderPainter(
                      shader: widget.controller.program!.fragmentShader(),
                      image: widget.controller.image!,
                      r: r,
                      g: g,
                      b: b,
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
