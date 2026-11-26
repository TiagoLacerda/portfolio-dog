import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:material_ui/material_ui.dart' hide Image;

import '../../core/adapters/webgl/fdog/enums/color_blending.dart';
import '../../core/adapters/webgl/fdog/fdog_shader_pipeline.dart';
import '../../core/adapters/webgl/fdog/fdog_shader_presets.dart';
import '../../core/adapters/webgl/fdog/fdog_shader_settings.dart';
import '../../core/utils/utils.dart';

final class HomeController extends ChangeNotifier {
  final settings = FdogShaderPresets.baseline;

  final pipeline = FDoGShaderPipeline();

  Image? image;

  Timer? _presetAnimation;

  ColorBlending get _colorBlending =>
      settings.useColorBlending ? settings.colorBlending : ColorBlending.none;

  @override
  void dispose() {
    _presetAnimation?.cancel();
    image?.dispose();

    super.dispose();
  }

  Future<void> initialize() async {
    try {
      await pipeline.initialize();

      image = await Utils.loadImageFromAsset('images/lena-forsen.png');

      if (image == null) return;

      await pipeline.setImage(image!);

      final colors = settings.useColorMapping ? settings.colors : <Color>[];

      pipeline.useColorQuantization = settings.useColorQuantization;
      pipeline.useColorMapping = settings.useColorMapping;
      pipeline.useCrossHatching = settings.useCrossHatching;
      pipeline.colorBlending = _colorBlending;
      pipeline.usePaperTexture = settings.usePaperTexture;
      pipeline.setColorMap(colors);
      pipeline.setScale(settings.scale);
      pipeline.draw(
        settings.sigmaC,
        settings.sigmaE,
        settings.sigmaM,
        settings.sigmaA,
        settings.k,
        settings.tau,
        settings.epsilon,
        settings.phi,
        settings.numColors,
        (
          settings.crossHatchingAngle1,
          settings.crossHatchingAngle2,
          settings.crossHatchingAngle3,
          settings.crossHatchingAngle4,
        ),
        (
          settings.crossHatchingThreshold1,
          settings.crossHatchingThreshold2,
          settings.crossHatchingThreshold3,
          settings.crossHatchingThreshold4,
        ),
        settings.crossHatchingScale,
      );
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> uploadImage() async {
    image?.dispose();
    image = null;

    image = await Utils.pickImage();

    if (image == null) return;

    await pipeline.setImage(image!);

    pipeline.setScale(settings.scale);

    draw();

    notifyListeners();
  }

  Future<void> onTapPencilPreset() => _applyPreset(FdogShaderPresets.pencil);

  Future<void> onTapCharcoalPreset() =>
      _applyPreset(FdogShaderPresets.charcoal);

  Future<void> onTapWoodblockPreset() =>
      _applyPreset(FdogShaderPresets.woodblock);

  Future<void> onTapWatercolorPreset() =>
      _applyPreset(FdogShaderPresets.watercolor);

  Future<void> onTapStippleBrushPreset() =>
      _applyPreset(FdogShaderPresets.stippleBrush);

  Future<void> onTapCrossHatchingPreset() =>
      _applyPreset(FdogShaderPresets.crossHatching);

  Future<void> downloadImage() async {
    await pipeline.saveImage('download.png');
  }

  void onSetColorMap(List<Color> colors) {
    pipeline.setColorMap(colors);
    draw();
  }

  void onSetScale() {
    pipeline.setScale(settings.scale);
    draw();
    notifyListeners();
  }

  void onSetUseColorQuantization() {
    pipeline.useColorQuantization = settings.useColorQuantization;
    draw();
  }

  void onSetUseColorMapping() {
    pipeline.useColorMapping = settings.useColorMapping;
    draw();
  }

  void onSetUseCrossHatching() {
    pipeline.useCrossHatching = settings.useCrossHatching;
    draw();
  }

  void onSetUseColorBlending() {
    pipeline.colorBlending = _colorBlending;
    draw();
  }

  void onSetUsePaperTexture() {
    pipeline.usePaperTexture = settings.usePaperTexture;
    draw();
  }

  void draw() {
    pipeline.draw(
      settings.sigmaC,
      settings.sigmaE,
      settings.sigmaM,
      settings.sigmaA,
      settings.k,
      settings.tau,
      settings.epsilon,
      settings.phi,
      settings.numColors,
      (
        settings.crossHatchingAngle1,
        settings.crossHatchingAngle2,
        settings.crossHatchingAngle3,
        settings.crossHatchingAngle4,
      ),
      (
        settings.crossHatchingThreshold1,
        settings.crossHatchingThreshold2,
        settings.crossHatchingThreshold3,
        settings.crossHatchingThreshold4,
      ),
      settings.crossHatchingScale,
    );
  }

  void _animateToShaderSettings(
    FDoGShaderSettings newSettings,
    VoidCallback onChangedSettings,
  ) {
    _presetAnimation?.cancel();

    final from = settings.copyWith();
    final to = newSettings;

    const duration = Duration(milliseconds: 250);
    final start = DateTime.now();

    _presetAnimation = Timer.periodic(
      Duration(milliseconds: (1000 / 144).floor()),
      (timer) {
        final t =
            (DateTime.now().difference(start).inMilliseconds /
                    duration.inMilliseconds)
                .clamp(0.0, 1.0);

        final next = from.lerp(to, t);

        final scaleChanged = next.scale != settings.scale;
        final colorMapChanged =
            next.colors != settings.colors ||
            next.useColorMapping != settings.useColorMapping;

        settings.setFrom(next);

        onChangedSettings();

        if (scaleChanged) {
          pipeline.setScale(
            settings.scale,
          );
        }

        pipeline.useColorQuantization = settings.useColorQuantization;
        pipeline.useColorMapping = settings.useColorMapping;
        pipeline.useCrossHatching = settings.useCrossHatching;
        pipeline.colorBlending = _colorBlending;
        pipeline.usePaperTexture = settings.usePaperTexture;

        if (colorMapChanged) {
          pipeline.setColorMap(
            settings.useColorMapping ? settings.colors : <Color>[],
          );
        }

        draw();

        if (t >= 1.0) {
          timer.cancel();
        }
      },
    );
  }

  Future<void> _applyPreset(FDoGShaderSettings preset) async {
    image?.dispose();
    image = null;

    image = await Utils.loadImageFromAsset('images/lena-forsen.png');

    if (image == null) return;

    await pipeline.setImage(image!);

    pipeline.setScale(settings.scale);

    _animateToShaderSettings(preset, notifyListeners);
  }
}
