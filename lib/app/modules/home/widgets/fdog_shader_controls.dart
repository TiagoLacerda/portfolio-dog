import 'dart:math';

import 'package:flutter/material.dart' hide Image;

import '../../../../l10n/generated/modular_localization.dart';
import 'fdog_shader_settings.dart';
import 'palette_generate_dialog.dart';
import 'palette_import_dialog.dart';
import 'palette_widget.dart';
import 'shader_checkbox.dart';
import 'shader_slider.dart';
import 'sound_button.dart';

class FDoGShaderControls extends StatefulWidget {
  final FDoGShaderSettings settings;
  final void Function() uploadImage;
  final void Function() downloadImage;
  final void Function() draw;
  final void Function() onSetScale;
  final void Function() onSetUseColorQuantization;
  final void Function() onSetUseColorMapping;
  final void Function() onSetUseColorBlending;
  final void Function(List<Color> colors) onSetColorMap;

  const FDoGShaderControls({
    super.key,
    required this.settings,
    required this.uploadImage,
    required this.downloadImage,
    required this.draw,
    required this.onSetScale,
    required this.onSetUseColorQuantization,
    required this.onSetUseColorMapping,
    required this.onSetUseColorBlending,
    required this.onSetColorMap,
  });

  @override
  State<FDoGShaderControls> createState() => FDoGShaderControlsState();
}

class FDoGShaderControlsState extends State<FDoGShaderControls> {
  List<Color> get grayscale => List.generate(
    widget.settings.numColors,
    (i) {
      final l = i / (widget.settings.numColors - 1);
      return Color.from(alpha: 1, red: l, green: l, blue: l);
    },
  );

  @override
  void initState() {
    super.initState();
    widget.settings.numColors = max(2, widget.settings.colors.length);
  }

  @override
  Widget build(BuildContext context) {
    final sliderRadius = ShaderSlider<int>(
      title: 'radius',
      subtitle: 'Gaussian blur radius',
      value: widget.settings.radius,
      min: widget.settings.radiusMin,
      max: widget.settings.radiusMax,
      getDivisions: (minValue, maxValue) => (maxValue - minValue).toInt(),
      decimals: 0,
      onChanged: (value) {
        widget.settings.radius = value;
        widget.draw();
      },
    );

    final sliderSigmaC = ShaderSlider(
      title: 'σ c',
      subtitle: 'Structure-tensor blur',
      value: widget.settings.sigmaC,
      min: widget.settings.sigmaCMin,
      max: widget.settings.sigmaCMax,
      onChanged: (value) {
        widget.settings.sigmaC = value;
        widget.draw();
      },
    );

    final sliderSigmaE = ShaderSlider(
      title: 'σ e',
      subtitle: 'Orthogonal blur',
      value: widget.settings.sigmaE,
      min: widget.settings.sigmaEMin,
      max: widget.settings.sigmaEMax,
      onChanged: (value) {
        widget.settings.sigmaE = value;
        widget.draw();
      },
    );

    final sliderSigmaM = ShaderSlider(
      title: 'σ m',
      subtitle: 'Tangent blur',
      value: widget.settings.sigmaM,
      min: widget.settings.sigmaMMin,
      max: widget.settings.sigmaMMax,
      onChanged: (value) {
        widget.settings.sigmaM = value;
        widget.draw();
      },
    );

    final sliderSigmaA = ShaderSlider(
      title: 'σ a',
      subtitle: 'Second LIC pass',
      value: widget.settings.sigmaA,
      min: widget.settings.sigmaAMin,
      max: widget.settings.sigmaAMax,
      onChanged: (value) {
        widget.settings.sigmaA = value;
        widget.draw();
      },
    );

    final sliderK = ShaderSlider(
      title: 'k',
      subtitle: 'DoG σ difference',
      value: widget.settings.k,
      min: widget.settings.kMin,
      max: widget.settings.kMax,
      onChanged: (value) {
        widget.settings.k = value;
        widget.draw();
      },
    );

    final sliderTau = ShaderSlider(
      title: 'τ',
      subtitle: 'DoG scaler',
      value: widget.settings.tau,
      min: widget.settings.tauMin,
      max: widget.settings.tauMax,
      onChanged: (value) {
        widget.settings.tau = value;
        widget.draw();
      },
    );

    final sliderEpsilon = ShaderSlider(
      title: 'ε',
      subtitle: 'DoG threshold',
      value: widget.settings.epsilon,
      min: widget.settings.epsilonMin,
      max: widget.settings.epsilonMax,
      onChanged: (value) {
        widget.settings.epsilon = value;
        widget.draw();
      },
    );

    final sliderPhi = ShaderSlider(
      title: 'φ',
      subtitle: 'DoG threshold smoothing',
      value: widget.settings.phi,
      min: widget.settings.phiMin,
      max: widget.settings.phiMax,
      onChanged: (value) {
        widget.settings.phi = value;
        widget.draw();
      },
    );

    final sliderScale = ShaderSlider(
      title: 'scale',
      subtitle: 'Rescale the image',
      value: widget.settings.scale,
      min: widget.settings.scaleMin,
      max: widget.settings.scaleMax,
      onChanged: (value) {
        widget.settings.scale = value;
        widget.onSetScale();
        widget.draw();
      },
    );

    final checkboxColorBlending = ShaderCheckbox(
      subtitle: 'Color-blending',
      initialValue: widget.settings.useColorBlending,
      onChanged: (value) {
        widget.settings.useColorBlending = value;
        widget.onSetUseColorBlending();
        widget.draw();
      },
    );

    final changeImageButton = IconButton(
      onPressed: widget.uploadImage,
      tooltip: ModularLocalization.localizations.modules.home.widgets.fdogShaderControls.changeImage,
      style: IconButton.styleFrom(
        backgroundColor: ColorScheme.of(context).primary,
        foregroundColor: ColorScheme.of(context).surface,
      ),
      icon: Icon(
        Icons.add_photo_alternate_outlined,
      ),
    );

    final downloadImageButton = IconButton(
      onPressed: () => widget.downloadImage(),
      tooltip: ModularLocalization.localizations.modules.home.widgets.fdogShaderControls.downloadImage,
      style: IconButton.styleFrom(
        backgroundColor: ColorScheme.of(context).primary,
        foregroundColor: ColorScheme.of(context).surface,
      ),
      icon: Icon(
        Icons.file_download_outlined,
      ),
    );

    final soundButton = SoundButton();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        sliderRadius,
        sliderSigmaC,
        sliderSigmaE,
        sliderSigmaM,
        sliderSigmaA,
        sliderK,
        sliderTau,
        sliderEpsilon,
        sliderPhi,
        sliderScale,
        StatefulBuilder(
          builder: (context, setState) {
            final decreaseButton = IconButton(
              onPressed: () {
                final numColors = max(2, widget.settings.numColors - 1);

                setState(() {
                  widget.settings.numColors = numColors;
                });

                if (widget.settings.numColors <= widget.settings.colors.length) {
                  widget.onSetColorMap(
                    widget.settings.colors.sublist(0, min(widget.settings.numColors, widget.settings.colors.length)),
                  );
                }

                widget.draw();
              },
              tooltip: ModularLocalization.localizations.modules.home.widgets.fdogShaderControls.decrease,
              icon: Icon(
                Icons.remove_circle_outline_rounded,
              ),
            );

            final increaseButton = IconButton(
              onPressed: () {
                setState(() {
                  widget.settings.numColors = widget.settings.numColors + 1;
                });

                if (widget.settings.numColors <= widget.settings.colors.length) {
                  widget.onSetColorMap(
                    widget.settings.colors.sublist(0, min(widget.settings.numColors, widget.settings.colors.length)),
                  );
                }

                widget.draw();
              },
              tooltip: ModularLocalization.localizations.modules.home.widgets.fdogShaderControls.increase,
              icon: Icon(
                Icons.add_circle_outline_rounded,
              ),
            );

            final checkboxColorQuantization = ShaderCheckbox(
              prefixText: 'colors: ',
              title: widget.settings.numColors.toString(),
              subtitle: 'Color-quantization',
              initialValue: widget.settings.useColorQuantization,
              onChanged: (value) {
                setState(() {
                  widget.settings.useColorQuantization = value;
                });

                widget.onSetUseColorQuantization();
                widget.draw();
              },
              trailing: Expanded(
                child: Row(
                  children: [
                    decreaseButton,
                    increaseButton,
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: PaletteWidget(
                        colors: grayscale,
                        divider: min(widget.settings.colors.length, widget.settings.numColors),
                      ),
                    ),
                  ],
                ),
              ),
            );

            final generatePaletteButton = IconButton(
              onPressed: () async {
                final palette = await showDialog<List<Color>>(
                  context: context,
                  builder: (_) => PaletteGenerateDialog(),
                );

                if (palette == null) return;

                setState(() {
                  widget.settings.colors = palette;
                });

                widget.onSetColorMap(widget.settings.colors);
                widget.draw();
              },
              tooltip: ModularLocalization.localizations.modules.home.widgets.fdogShaderControls.generatePalette,
              icon: Icon(
                Icons.palette,
              ),
            );

            final importPaletteButton = IconButton(
              onPressed: () async {
                final palette = await showDialog<List<Color>>(
                  context: context,
                  builder: (_) => PaletteImportDialog(
                    colors: widget.settings.colors,
                  ),
                );

                if (palette == null) return;

                setState(() {
                  widget.settings.colors = palette;
                });

                widget.onSetColorMap(widget.settings.colors);
                widget.draw();
              },
              tooltip: ModularLocalization.localizations.modules.home.widgets.fdogShaderControls.importPalette,
              icon: Icon(
                Icons.paste_rounded,
              ),
            );

            final checkboxColorMapping = ShaderCheckbox(
              subtitle: 'Color-mapping',
              initialValue: widget.settings.useColorMapping,
              enabled: widget.settings.useColorQuantization,
              onChanged: (value) {
                setState(() {
                  widget.settings.useColorMapping = value;
                });

                widget.onSetUseColorMapping();
                widget.draw();
              },
              trailing: Expanded(
                child: Row(
                  children: [
                    generatePaletteButton,
                    importPaletteButton,
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: PaletteWidget(
                        colors: widget.settings.colors,
                        divider: min(widget.settings.colors.length, widget.settings.numColors),
                      ),
                    ),
                  ],
                ),
              ),
            );

            return Column(
              children: [
                checkboxColorQuantization,
                checkboxColorMapping,
              ],
            );
          },
        ),
        checkboxColorBlending,
        SizedBox(
          height: 16.0,
        ),
        Row(
          spacing: 8.0,
          children: [
            changeImageButton,
            downloadImageButton,
            soundButton,
          ],
        ),
      ],
    );
  }
}
