import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/modules/home/widgets/shader_checkbox.dart';

import '../../../core/utils/utils.dart';
import '../my_shader_pipeline.dart';
import 'shader_slider.dart';
import 'sound_button.dart';

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
  double sigmaC = 0.075;
  double sigmaE = 0.5;
  double sigmaM = 10.0;
  double sigmaA = 4.8;
  double k = 1.6;
  double tau = 100.0;
  double epsilon = 0.3;
  double phi = 0.9;
  double scale = 0.347;

  int numColors = 8;

  bool useColorQuantization = true;
  bool useColorMapping = true;
  bool useColorBlending = true;

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

  void draw() => widget.pipeline.draw(sigmaC, sigmaM, sigmaE, sigmaA, k, tau, epsilon, phi, numColors);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () async {
                final image = await Utils.pickImage();

                if (image == null) return;

                setState(() => scale = 1.0);

                widget.pipeline.setScale(scale);
                await widget.pipeline.setImage(image);

                draw();
              },
              tooltip: 'Change image',
              style: IconButton.styleFrom(
                backgroundColor: ColorScheme.of(context).primary,
                foregroundColor: ColorScheme.of(context).surface,
              ),
              icon: Icon(
                Icons.add_photo_alternate_outlined,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            IconButton(
              onPressed: () => widget.pipeline.saveImage('download.png'),
              tooltip: 'Download image',
              style: IconButton.styleFrom(
                backgroundColor: ColorScheme.of(context).primary,
                foregroundColor: ColorScheme.of(context).surface,
              ),
              icon: Icon(
                Icons.file_download_outlined,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            SoundButton(),
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
        ShaderCheckbox(
          subtitle: 'Color-quantization',
          initialValue: useColorQuantization,
          onChanged: (value) {
            setState(() {
              useColorQuantization = value;
            });

            widget.pipeline.useColorQuantization = useColorQuantization;
            draw();
          },
        ),
        if (useColorQuantization) ...[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: ShaderCheckbox(
              subtitle: 'Color-mapping',
              initialValue: useColorMapping,
              onChanged: (value) {
                setState(() {
                  useColorMapping = value;
                });

                widget.pipeline.useColorMapping = useColorMapping;
                draw();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: ShaderSlider(
              title: 'Colors',
              subtitle: '',
              value: numColors.toDouble(),
              min: 2.0,
              max: 8.0,
              divisions: 6,
              onChanged: (value) {
                numColors = value.toInt();
                draw();
              },
            ),
          ),
        ],
        ShaderCheckbox(
          subtitle: 'Color-blending',
          initialValue: useColorBlending,
          onChanged: (value) {
            useColorBlending = value;
            widget.pipeline.useColorBlending = useColorBlending;
            draw();
          },
        ),
      ],
    );
  }
}
