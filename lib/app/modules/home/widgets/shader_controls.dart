import 'package:flutter/material.dart' hide Image;

import '../../../core/utils/utils.dart';
import '../my_shader_pipeline.dart';
import 'shader_slider.dart';

class ShaderControls extends StatefulWidget {
  final MyShaderPipeline pipeline;

  const ShaderControls({
    super.key,
    required this.pipeline,
  });

  @override
  State<ShaderControls> createState() => ShaderControlsState();
}

class ShaderControlsState extends State<ShaderControls> {
  double sigmaC = 2.5;
  double sigmaM = 10.0;
  double sigmaE = 2.8;
  double sigmaA = 0.25;
  double k = 2.4;
  double tau = 40.0;
  double epsilon = 0.235;
  double phi = 4.645;
  double scale = 1.0;

  bool useColorMapping = true;

  List<Color> colors = [
    Color(0xFF0E3738),
    Color(0xFF1B3F5D),
    Color(0xFF3B4479),
    Color(0xFF694A7E),
    Color(0xFF9C556E),
    Color(0xFFBF6A5C),
    Color(0xFFC78C56),
    Color(0xFFB5B96A),
  ];

  void draw() => widget.pipeline.draw(sigmaC, sigmaM, sigmaE, sigmaA, k, tau, epsilon, phi);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final image = await Utils.pickImage();

                if (image == null) return;

                setState(() => scale = 1.0);

                widget.pipeline.setScale(scale);
                await widget.pipeline.setImage(image);

                draw();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorScheme.of(context).primary,
                foregroundColor: ColorScheme.of(context).surface,
                textStyle: TextTheme.of(context).labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
              ),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () => widget.pipeline.saveImage('download.png'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorScheme.of(context).primary,
                foregroundColor: ColorScheme.of(context).surface,
                textStyle: TextTheme.of(context).labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Icon(
                Icons.save_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ShaderSlider(
          title: 'σ c',
          subtitle: 'Structure-tensor blur',
          value: sigmaC,
          min: 0.001,
          max: 10.0,
          onChanged: (value) {
            sigmaC = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'σ e',
          subtitle: 'Orthogonal blur',
          value: sigmaE,
          min: 0.001,
          max: 10.0,
          onChanged: (value) {
            sigmaE = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'σ m',
          subtitle: 'Tangent blur',
          value: sigmaM,
          min: 0.001,
          max: 10.0,
          onChanged: (value) {
            sigmaM = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'σ a',
          subtitle: 'Second LIC pass',
          value: sigmaA,
          min: 0.001,
          max: 10.0,
          onChanged: (value) {
            sigmaA = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'k',
          subtitle: 'DoG σ difference',
          value: k,
          min: 1.0,
          max: 10.0,
          onChanged: (value) {
            k = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'τ',
          subtitle: 'DoG scaler',
          value: tau,
          min: 0.0,
          max: 100.0,
          onChanged: (value) {
            tau = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'ε',
          subtitle: 'DoG threshold',
          value: epsilon,
          min: 0.0,
          max: 1.0,
          onChanged: (value) {
            epsilon = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'φ',
          subtitle: 'DoG threshold smoothing',
          value: phi,
          min: 0.0,
          max: 10.0,
          onChanged: (value) {
            phi = value;
            draw();
          },
        ),
        ShaderSlider(
          title: 'scale',
          subtitle: 'Downscale the image',
          value: scale,
          min: 0.0,
          max: 1.0,
          onChanged: (value) {
            scale = value;
            widget.pipeline.setScale(scale);
            draw();
          },
        ),
        Row(
          children: [
            SizedBox(
              width: 150.0,
              child: Text(
                'Color-mapping',
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w100,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: useColorMapping,
                  onChanged: (value) {
                    setState(() => useColorMapping = value!);

                    if (useColorMapping) {
                      widget.pipeline.setColorMap(colors);
                    } else {
                      widget.pipeline.setColorMap([]);
                    }
                    
                    draw();
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
