// import 'package:flutter/material.dart';
// import 'package:flutter_shaders/app/modules/home/my_shader_pipeline.dart';

// class ShaderControls extends StatefulWidget {
//   const ShaderControls({super.key});

//   @override
//   State<ShaderControls> createState() => ShaderControlsState();
// }

// class ShaderControlsState extends State<ShaderControls> {
//   MyShaderPipeline? pipeline;

//   int radius = 5;
//   double sigmaC = 2.5;
//   double sigmaM = 3.0;
//   double sigmaE = 2.8;
//   double sigmaA = 0.25;
//   double k = 2.4;
//   double tau = 40.0;
//   double epsilon = 0.6;
//   double phi = 10.0;
//   double s = 0.0;

//   void draw() {
//     pipeline?.draw(radius, sigmaC, sigmaM, sigmaE, sigmaA, k, tau, epsilon, phi, s);
//   }

//   @override
//   void initState() {
//     super.initState();

//     var p = MyShaderPipeline(
//       width: 325,
//       height: 288,
//     );
//     p.initialize().then((_) {
//       pipeline = p;
//       draw();
//     });
//   }

//   Widget buildSlider({
//     required BuildContext context,
//     required String label,
//     required String subtitle,
//     required num value,
//     required num min,
//     required num max,
//     required void Function(num) onChanged,
//     int? divisions,
//     int pad = 10,
//   }) {
//     final decimals = value is double ? 3 : 0;

//     return Row(
//       children: [
//         SizedBox(
//           width: 150.0,
//           child: FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   subtitle,
//                   style: TextTheme.of(context).bodyMedium?.copyWith(
//                     color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
//                     fontSize: 10.0,
//                     fontWeight: FontWeight.w100,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//                 RichText(
//                   maxLines: 1,
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '$label:  ',
//                         style: TextTheme.of(context).bodyMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                       TextSpan(
//                         text: value.toStringAsFixed(decimals),
//                         style: TextTheme.of(context).bodyMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Text(
//           min.toStringAsFixed(decimals).padLeft(pad),
//           style: TextTheme.of(context).bodyMedium,
//         ),
//         Expanded(
//           child: Slider(
//             value: value.toDouble(),
//             min: min.toDouble(),
//             max: max.toDouble(),
//             divisions: divisions,
//             onChanged: onChanged,
//           ),
//         ),
//         Text(
//           max.toStringAsFixed(decimals).padLeft(pad),
//           style: TextTheme.of(context).bodyMedium,
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         buildSlider(
//           context: context,
//           label: 'radius',
//           subtitle: 'Structure-tensor blur',
//           value: radius,
//           min: 1,
//           max: 9,
//           divisions: 8,
//           onChanged: (value) => setState(() {
//             radius = value.toInt();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'σ c',
//           subtitle: 'Structure-tensor blur',
//           value: sigmaC,
//           min: 0.001,
//           max: 10.0,
//           onChanged: (value) => setState(() {
//             sigmaC = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'σ e',
//           subtitle: 'Orthogonal blur',
//           value: sigmaE,
//           min: 0.001,
//           max: 10.0,
//           onChanged: (value) => setState(() {
//             sigmaE = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'σ m',
//           subtitle: 'Tangent blur',
//           value: sigmaM,
//           min: 0.001,
//           max: 10.0,
//           onChanged: (value) => setState(() {
//             sigmaM = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'σ a',
//           subtitle: 'Second LIC pass',
//           value: sigmaA,
//           min: 0.001,
//           max: 10.0,
//           onChanged: (value) => setState(() {
//             sigmaA = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'k',
//           subtitle: 'DoG σ difference',
//           value: k,
//           min: 1.0,
//           max: 10.0,
//           onChanged: (value) => setState(() {
//             k = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'τ',
//           subtitle: 'DoG scaler',
//           value: tau,
//           min: 0.0,
//           max: 100.0,
//           onChanged: (value) => setState(() {
//             tau = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'ε',
//           subtitle: 'DoG threshold',
//           value: epsilon,
//           min: 0.0,
//           max: 1.0,
//           onChanged: (value) => setState(() {
//             epsilon = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 'φ',
//           subtitle: 'DoG threshold smoothing',
//           value: phi,
//           min: 0.0,
//           max: 10.0,
//           onChanged: (value) => setState(() {
//             phi = value.toDouble();
//             draw();
//           }),
//         ),
//         buildSlider(
//           context: context,
//           label: 's',
//           subtitle: 'Dither spread',
//           value: s,
//           min: 0.0,
//           max: 1.0,
//           onChanged: (value) => setState(() {
//             s = value.toDouble();
//             draw();
//           }),
//         ),
//       ],
//     );
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/modules/home/my_shader_pipeline.dart';

class ShaderControls extends StatefulWidget {
  final Future<Image?> Function()? loadImage;

  const ShaderControls({
    super.key,
    this.loadImage,
  });

  @override
  State<ShaderControls> createState() => ShaderControlsState();
}

class ShaderControlsState extends State<ShaderControls> {
  MyShaderPipeline? pipeline;

  int radius = 5;
  double sigmaC = 2.5;
  double sigmaM = 3.0;
  double sigmaE = 2.8;
  double sigmaA = 0.25;
  double k = 2.4;
  double tau = 40.0;
  double epsilon = 0.235;
  double phi = 4.645;
  double s = 0.0;

  void draw() {
    pipeline?.draw(radius, sigmaC, sigmaM, sigmaE, sigmaA, k, tau, epsilon, phi, s);
  }

  @override
  void initState() {
    super.initState();

    var p = MyShaderPipeline(
      width: 325,
      height: 288,
    );
    p.initialize().then((_) {
      pipeline = p;
      draw();
    });
  }

  Widget buildSlider({
    required BuildContext context,
    required String label,
    required String subtitle,
    required num value,
    required num min,
    required num max,
    required void Function(num) onChanged,
    int? divisions,
    int pad = 10,
  }) {
    final decimals = value is double ? 3 : 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            SizedBox(
              width: 150.0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$label:  ',
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
                  ],
                ),
              ),
            ),
            Text(
              min.toStringAsFixed(decimals).padLeft(pad),
              style: TextTheme.of(context).bodyMedium,
            ),
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: divisions,
                onChanged: (value) => setState(() {
                  onChanged(value);
                  draw();
                }),
              ),
            ),
            Text(
              max.toStringAsFixed(decimals).padLeft(pad),
              style: TextTheme.of(context).bodyMedium,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            widget.loadImage?.call().then((image) async {
              if (image != null) {
                await pipeline?.setImage(image);
                draw();
              }
            });
          },
          style: ElevatedButton.styleFrom(
            surfaceTintColor: ColorScheme.of(context).primary,
          ),
          child: Text('Load image'),
        ),
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
          }),
        ),
        buildSlider(
          context: context,
          label: 'σ a',
          subtitle: 'Second LIC pass',
          value: sigmaA,
          min: 0.001,
          max: 10.0,
          onChanged: (value) => setState(() {
            sigmaA = value.toDouble();
          }),
        ),
        buildSlider(
          context: context,
          label: 'k',
          subtitle: 'DoG σ difference',
          value: k,
          min: 1.0,
          max: 10.0,
          onChanged: (value) => setState(() {
            k = value.toDouble();
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
          }),
        ),
      ],
    );
  }
}
