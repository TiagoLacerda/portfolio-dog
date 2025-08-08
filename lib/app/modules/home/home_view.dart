// import 'package:flutter/material.dart';
// import 'package:flutter_shaders/app/core/utils/shader_painter.dart';
// import 'package:flutter_shaders/app/modules/home/home_controller.dart';

// class HomeView extends StatefulWidget {
//   final HomeController controller;

//   const HomeView({
//     super.key,
//     required this.controller,
//   });

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   int maxRadius = 31;
//   int radius = 0;
//   double sigma = 0.0;
//   double k = 0.5;

//   Widget buildSlider(
//     BuildContext context, {
//     String? label,
//     required double value,
//     required void Function(double newValue) onChanged,
//     double min = 0.0,
//     double max = 1.0,
//     int? divisions,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: SizedBox(
//             width: 160.0,
//             child: Row(
//               children: [
//                 if (label != null) ...[
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       right: 16.0,
//                     ),
//                     child: Text('$label: '),
//                   ),
//                 ],
//                 Text(
//                   value.toStringAsFixed(4),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         VerticalDivider(),
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: SizedBox(
//             width: 80.0,
//             child: Text(
//               'min.: ${min.toStringAsFixed(4)}',
//             ),
//           ),
//         ),
//         Expanded(
//           child: Slider(
//             value: value,
//             min: min,
//             max: max,
//             onChanged: onChanged,
//             divisions: divisions,
//           ),
//         ),
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: SizedBox(
//             width: 80.0,
//             child: Text(
//               'max.: ${max.toStringAsFixed(4)}',
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: widget.controller,
//       builder: (_, _) => Scaffold(
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: widget.controller.loadImage,
//                 child: Text('Load image'),
//               ),
//               if (widget.controller.image == null) ...[
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 16.0,
//                   ),
//                   child: Text('No image currently loaded.'),
//                 ),
//               ] else ...[
//                 buildSlider(
//                   context,
//                   label: 'Radius',
//                   value: radius.toDouble(),
//                   onChanged: (value) => setState(() => radius = value.floor()),
//                   max: 31.0,
//                   divisions: 31,
//                 ),
//                 buildSlider(
//                   context,
//                   label: 'Sigma',
//                   value: sigma,
//                   max: 100.0,
//                   onChanged: (value) => setState(() => sigma = value),
//                 ),
//                 buildSlider(
//                   context,
//                   label: 'k',
//                   value: k,
//                   onChanged: (value) => setState(() => k = value),
//                 ),
//                 ColoredBox(
//                   color: Colors.black,
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: CustomPaint(
//                       size: Size(
//                         widget.controller.image!.width.toDouble(),
//                         widget.controller.image!.height.toDouble(),
//                       ),
//                       painter: ShaderPainter(
//                         blur: widget.controller.blur!.fragmentShader(),
//                         dog: widget.controller.dog!.fragmentShader(),
//                         image: widget.controller.image!,
//                         radius: radius,
//                         sigma: sigma,
//                         k: k,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/core/utils/shader_painter.dart';
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
  int maxRadius = 31;
  int radius = 5;
  double sigma = 1.4;
  double k = 0.5;
  double epsilon = 0.5;

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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: widget.controller.loadImage,
                child: Text('Load image'),
              ),
              if (widget.controller.image == null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('No image currently loaded.'),
                ),
              ] else ...[
                buildSlider(
                  context,
                  label: 'Radius',
                  value: radius.toDouble(),
                  onChanged: (value) => setState(() => radius = value.floor()),
                  max: 31.0,
                  divisions: 31,
                ),
                buildSlider(
                  context,
                  label: 'Sigma',
                  value: sigma,
                  max: 20.0,
                  onChanged: (value) => setState(() => sigma = value),
                ),
                buildSlider(
                  context,
                  label: 'k',
                  value: k,
                  onChanged: (value) => setState(() => k = value),
                ),
                buildSlider(
                  context,
                  label: 'ε',
                  value: epsilon,
                  onChanged: (value) => setState(() => epsilon = value),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.black,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomPaint(
                        size: Size(
                          widget.controller.image!.width.toDouble(),
                          widget.controller.image!.height.toDouble(),
                        ),
                        painter: ShaderPainter(
                          blur: widget.controller.blur!.fragmentShader(),
                          dog: widget.controller.dog!.fragmentShader(),
                          image: widget.controller.image!,
                          radius: radius,
                          sigma: sigma,
                          k: k,
                          epsilon: epsilon,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
