import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/core/shader_pipeline.dart';
import 'package:flutter_shaders/app/modules/home/home_controller.dart';

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
  late ShaderPipeline shaderPipeline;
  double radius = 5;
  double sigma = 1.4;

  @override
  void initState() {
    super.initState();

    try {
      shaderPipeline = ShaderPipeline();
      shaderPipeline.initialize();
    } catch (e) {
      log(e.toString());
    }
  }

  Widget buildSlider(
    BuildContext context, {
    String? label,
    required double value,
    required void Function(double newValue) onChanged,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 160.0,
            child: Row(
              children: [
                if (label != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: Text('$label: '),
                  ),
                ],
                Text(
                  value.toStringAsFixed(4),
                ),
              ],
            ),
          ),
        ),
        VerticalDivider(),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 80.0,
            child: Text(
              'min.: ${min.toStringAsFixed(4)}',
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            divisions: divisions,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 80.0,
            child: Text(
              'max.: ${max.toStringAsFixed(4)}',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, _) => Scaffold(
        body: Column(
          children: [
            buildSlider(
              context,
              label: 'Radius',
              value: radius,
              min: 1.0,
              max: 31.0,
              onChanged: (value) => setState(() {
                radius = value;
                shaderPipeline.draw(shaderPipeline.gl, radius, sigma);
              }),
            ),
            buildSlider(
              context,
              label: 'Sigma',
              value: sigma,
              min: 1.0,
              max: 10.0,
              onChanged: (value) => setState(() {
                sigma = value;
                shaderPipeline.draw(shaderPipeline.gl, radius, sigma);
              }),
            ),
            Expanded(
              child: HtmlElementView(viewType: 'webgl-canvas'),
            ),
          ],
        ),
      ),
    );
  }
}
