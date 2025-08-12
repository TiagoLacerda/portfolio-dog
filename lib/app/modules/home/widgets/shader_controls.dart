import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/modules/home/my_shader_pipeline.dart';

class ShaderControls extends StatefulWidget {
  const ShaderControls({super.key});

  @override
  State<ShaderControls> createState() => ShaderControlsState();
}

class ShaderControlsState extends State<ShaderControls> {
  MyShaderPipeline? pipeline;

  int radius = 5;
  double sigmaC = 2.5;
  double sigmaM = 1.0;
  double sigmaE = 2.8;
  double sigmaA = 1.0;
  double k = 2.4;
  double tau = 40.0;
  double epsilon = 0.6;
  double phi = 10.0;
  double s = 0.0;

  void draw() {
    pipeline?.draw(radius, sigmaC, sigmaM, sigmaE, sigmaA, k, tau, epsilon, phi, s);
  }

  @override
  void initState() {
    super.initState();

    var p = MyShaderPipeline();
    p.initialize().then((_) {
      pipeline = p;
      draw();
    });
  }

  Widget buildSlider({
    required BuildContext context,
    required String label,
    String? subtitle,
    required num value,
    required num min,
    required num max,
    required void Function(num) onChanged,
    int? divisions,
  }) {
    final decimals = value is double ? 3 : 0;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 200.0,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: RichText(
              maxLines: 1,
              text: TextSpan(
                children: [
                  if (subtitle != null) ...[
                    TextSpan(
                      text: subtitle,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  TextSpan(
                    text: '  $label:  ',
                    style: TextTheme.of(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: value.toStringAsFixed(decimals),
                    style: TextTheme.of(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          ' [${min.toStringAsFixed(decimals).padLeft(10, ' ')}, ${max.toStringAsFixed(decimals).padLeft(10, ' ')}]',
          style: TextTheme.of(context).bodyMedium,
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildSlider(
          context: context,
          label: 'radius',
          subtitle: 'Structure-tensor blur',
          value: radius,
          min: 1,
          max: 9,
          divisions: 8,
          onChanged: (value) => setState(() {
            radius = value.toInt();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 'σ c',
          subtitle: 'Structure-tensor blur',
          value: sigmaC,
          min: 0.001,
          max: 10.0,
          onChanged: (value) => setState(() {
            sigmaC = value.toDouble();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 'σ m',
          subtitle: 'Tangent blur',
          value: sigmaM,
          min: 0.001,
          max: 10.0,
          onChanged: (value) => setState(() {
            sigmaM = value.toDouble();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 'σ e',
          subtitle: 'Orthogonal blur',
          value: sigmaE,
          min: 0.001,
          max: 10.0,
          onChanged: (value) => setState(() {
            sigmaE = value.toDouble();
            draw();
          }),
        ),
        // buildSlider(
        //   context: context,
        //   label: 'σ a',
        //   value: sigmaA,
        //   min: 0.001,
        //   max: 10.0,
        //   onChanged: (value) => setState(() {
        //     sigmaA = value.toDouble();
        //     draw();
        //   }),
        // ),
        buildSlider(
          context: context,
          label: 'k',
          subtitle: 'DoG σ difference',
          value: k,
          min: 1.0,
          max: 10.0,
          onChanged: (value) => setState(() {
            k = value.toDouble();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 'τ',
          subtitle: 'DoG scaler',
          value: tau,
          min: 0.0,
          max: 100.0,
          onChanged: (value) => setState(() {
            tau = value.toDouble();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 'ε',
          subtitle: 'DoG threshold',
          value: epsilon,
          min: 0.0,
          max: 1.0,
          onChanged: (value) => setState(() {
            epsilon = value.toDouble();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 'φ',
          subtitle: 'DoG threshold smoothing',
          value: phi,
          min: 0.0,
          max: 10.0,
          onChanged: (value) => setState(() {
            phi = value.toDouble();
            draw();
          }),
        ),
        buildSlider(
          context: context,
          label: 's',
          subtitle: 'Dither spread',
          value: s,
          min: 0.0,
          max: 1.0,
          onChanged: (value) => setState(() {
            s = value.toDouble();
            draw();
          }),
        ),
      ],
    );
  }
}
