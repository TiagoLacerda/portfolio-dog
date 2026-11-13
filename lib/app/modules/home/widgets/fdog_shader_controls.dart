import 'dart:math';

import 'package:flutter/material.dart' hide Image;

import '../../../../l10n/generated/modular_localization.dart';
import '../../../core/adapters/webgl/fdog/enums/color_blending.dart';
import '../../../core/adapters/webgl/fdog/fdog_shader_settings.dart';
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
  final void Function() onSetUseCrossHatching;
  final void Function() onSetUseColorBlending;
  final void Function() onSetUsePaperTexture;
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
    required this.onSetUseCrossHatching,
    required this.onSetUseColorBlending,
    required this.onSetUsePaperTexture,
    required this.onSetColorMap,
  });

  @override
  State<FDoGShaderControls> createState() => FDoGShaderControlsState();
}

class FDoGShaderControlsState extends State<FDoGShaderControls> {
  bool isCrossHatchingExpanded = false;

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
    final textTheme = TextTheme.of(context);

    final sliderSigmaC = ShaderSlider(
      title: 'σ c',
      subtitle: 'Structure-tensor blur',
      value: widget.settings.sigmaC,
      min: widget.settings.sigmaCMin,
      max: widget.settings.sigmaCMax,
      onChangedRange: (min, max) {
        widget.settings.sigmaCMin = min;
        widget.settings.sigmaCMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.sigmaEMin = min;
        widget.settings.sigmaEMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.sigmaMMin = min;
        widget.settings.sigmaMMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.sigmaAMin = min;
        widget.settings.sigmaAMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.kMin = min;
        widget.settings.kMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.tauMin = min;
        widget.settings.tauMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.epsilonMin = min;
        widget.settings.epsilonMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.phiMin = min;
        widget.settings.phiMax = max;
      },
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
      onChangedRange: (min, max) {
        widget.settings.scaleMin = min;
        widget.settings.scaleMax = max;
      },
      onChanged: (value) {
        widget.settings.scale = value;
        widget.onSetScale();
        widget.draw();
      },
    );

    final checkboxCrossHatching = ShaderCheckbox(
      subtitle: 'Cross-hatching',
      initialValue: widget.settings.useCrossHatching,
      onChanged: (value) {
        setState(() {
          widget.settings.useCrossHatching = value;
        });

        widget.onSetUseCrossHatching();
      },
      trailing: Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => setState(() => isCrossHatchingExpanded = !isCrossHatchingExpanded),
            icon: Icon(
              isCrossHatchingExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            ),
          ),
        ),
      ),
    );

    final sliderCrossHatchingScale = ShaderSlider(
      title: 'scale',
      subtitle: 'Hatching texture scale',
      value: widget.settings.crossHatchingScale,
      min: widget.settings.crossHatchingScaleMin,
      max: widget.settings.crossHatchingScaleMax,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingScaleMin = min;
        widget.settings.crossHatchingScaleMax = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingScale = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingAngle1 = ShaderSlider(
      title: 'θ 1',
      subtitle: 'Hatching layer 1 angle',
      value: widget.settings.crossHatchingAngle1,
      min: widget.settings.crossHatchingAngle1Min,
      max: widget.settings.crossHatchingAngle1Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingAngle1Min = min;
        widget.settings.crossHatchingAngle1Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingAngle1 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingThreshold1 = ShaderSlider(
      title: 'ℓ 1',
      subtitle: 'Hatching layer 1 threshold',
      value: widget.settings.crossHatchingThreshold1,
      min: widget.settings.crossHatchingThreshold1Min,
      max: widget.settings.crossHatchingThreshold1Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingThreshold1Min = min;
        widget.settings.crossHatchingThreshold1Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingThreshold1 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingAngle2 = ShaderSlider(
      title: 'θ 2',
      subtitle: 'Hatching layer 2 angle',
      value: widget.settings.crossHatchingAngle2,
      min: widget.settings.crossHatchingAngle2Min,
      max: widget.settings.crossHatchingAngle2Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingAngle2Min = min;
        widget.settings.crossHatchingAngle2Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingAngle2 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingThreshold2 = ShaderSlider(
      title: 'ℓ 2',
      subtitle: 'Hatching layer 2 threshold',
      value: widget.settings.crossHatchingThreshold2,
      min: widget.settings.crossHatchingThreshold2Min,
      max: widget.settings.crossHatchingThreshold2Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingThreshold2Min = min;
        widget.settings.crossHatchingThreshold2Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingThreshold2 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingAngle3 = ShaderSlider(
      title: 'θ 3',
      subtitle: 'Hatching layer 3 angle',
      value: widget.settings.crossHatchingAngle3,
      min: widget.settings.crossHatchingAngle3Min,
      max: widget.settings.crossHatchingAngle3Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingAngle3Min = min;
        widget.settings.crossHatchingAngle3Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingAngle3 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingThreshold3 = ShaderSlider(
      title: 'ℓ 3',
      subtitle: 'Hatching layer 3 threshold',
      value: widget.settings.crossHatchingThreshold3,
      min: widget.settings.crossHatchingThreshold3Min,
      max: widget.settings.crossHatchingThreshold3Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingThreshold3Min = min;
        widget.settings.crossHatchingThreshold3Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingThreshold3 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingAngle4 = ShaderSlider(
      title: 'θ 4',
      subtitle: 'Hatching layer 4 angle',
      value: widget.settings.crossHatchingAngle4,
      min: widget.settings.crossHatchingAngle4Min,
      max: widget.settings.crossHatchingAngle4Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingAngle4Min = min;
        widget.settings.crossHatchingAngle4Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingAngle4 = value;
        widget.draw();
      },
    );

    final sliderCrossHatchingThreshold4 = ShaderSlider(
      title: 'ℓ 4',
      subtitle: 'Hatching layer 4 threshold',
      value: widget.settings.crossHatchingThreshold4,
      min: widget.settings.crossHatchingThreshold4Min,
      max: widget.settings.crossHatchingThreshold4Max,
      enabled: widget.settings.useCrossHatching,
      onChangedRange: (min, max) {
        widget.settings.crossHatchingThreshold4Min = min;
        widget.settings.crossHatchingThreshold4Max = max;
      },
      onChanged: (value) {
        widget.settings.crossHatchingThreshold4 = value;
        widget.draw();
      },
    );

    final radioLabelStyle = textTheme.bodyMedium?.copyWith(
      color: textTheme.bodyMedium?.color?.withValues(
        alpha: widget.settings.useColorBlending ? 1.0 : 0.5,
      ),
    );

    final checkboxColorBlending = ShaderCheckbox(
      subtitle: 'Color-blending',
      initialValue: widget.settings.useColorBlending,
      onChanged: (value) {
        setState(() {
          widget.settings.useColorBlending = value;
        });

        widget.onSetUseColorBlending();
        widget.draw();
      },
      trailing: RadioGroup<ColorBlending>(
        groupValue: widget.settings.colorBlending,
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            widget.settings.colorBlending = value;
          });

          widget.onSetUseColorBlending();
          widget.draw();
        },
        child: Row(
          children: [
            Radio<ColorBlending>(
              value: ColorBlending.linear,
              enabled: widget.settings.useColorBlending,
            ),
            Text(
              'Linear',
              style: radioLabelStyle,
            ),
            Radio<ColorBlending>(
              value: ColorBlending.twoPointLinear,
              enabled: widget.settings.useColorBlending,
            ),
            Text(
              'Two-point',
              style: radioLabelStyle,
            ),
            Radio<ColorBlending>(
              value: ColorBlending.bicubic,
              enabled: widget.settings.useColorBlending,
            ),
            Text(
              'Bicubic',
              style: radioLabelStyle,
            ),
          ],
        ),
      ),
    );

    final checkboxPaperTexture = ShaderCheckbox(
      subtitle: 'Paper texture',
      initialValue: widget.settings.usePaperTexture,
      onChanged: (value) {
        widget.settings.usePaperTexture = value;
        widget.onSetUsePaperTexture();
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
        checkboxCrossHatching,
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: isCrossHatchingExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sliderCrossHatchingScale,
                    sliderCrossHatchingAngle1,
                    sliderCrossHatchingThreshold1,
                    sliderCrossHatchingAngle2,
                    sliderCrossHatchingThreshold2,
                    sliderCrossHatchingAngle3,
                    sliderCrossHatchingThreshold3,
                    sliderCrossHatchingAngle4,
                    sliderCrossHatchingThreshold4,
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
        checkboxColorBlending,
        checkboxPaperTexture,
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
