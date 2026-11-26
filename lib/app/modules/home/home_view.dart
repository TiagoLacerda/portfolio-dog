import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_options_button/overlay_options_button.dart';
import 'package:portfolio_design_system/portfolio_design_system.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/generated/modular_localization.dart';
import '../../app_controller.dart';
import 'home_controller.dart';
import 'widgets/comparison_slider.dart';
import 'widgets/fdog_shader_controls.dart';

class HomeView extends StatefulWidget {
  final HomeController controller;
  final double spacing;

  const HomeView({
    super.key,
    required this.controller,
    this.spacing = 16.0,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();
  final transformationController = TransformationController();

  final isHovering = ValueNotifier<bool>(false);

  late final pencilRecognizer = TapGestureRecognizer()
    ..onTap = widget.controller.onTapPencilPreset;
  late final charcoalRecognizer = TapGestureRecognizer()
    ..onTap = widget.controller.onTapCharcoalPreset;
  late final woodblockRecognizer = TapGestureRecognizer()
    ..onTap = widget.controller.onTapWoodblockPreset;
  late final watercolorRecognizer = TapGestureRecognizer()
    ..onTap = widget.controller.onTapWatercolorPreset;
  late final stippleBrushRecognizer = TapGestureRecognizer()
    ..onTap = widget.controller.onTapStippleBrushPreset;
  late final crossHatchingRecognizer = TapGestureRecognizer()
    ..onTap = widget.controller.onTapCrossHatchingPreset;
  late final paperRecognizer = TapGestureRecognizer()
    ..onTap = () =>
        launchUrl(Uri.parse('https://doi.org/10.1016/j.cag.2012.03.004'));

  @override
  void dispose() {
    scrollController.dispose();
    transformationController.dispose();
    isHovering.dispose();
    pencilRecognizer.dispose();
    charcoalRecognizer.dispose();
    woodblockRecognizer.dispose();
    watercolorRecognizer.dispose();
    stippleBrushRecognizer.dispose();
    crossHatchingRecognizer.dispose();
    paperRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeButton = IconButton(
      onPressed: () => launchUrl(
        Uri.parse('https://tiagomlbrasil.com'),
        webOnlyWindowName: '_self',
      ),
      tooltip: ModularLocalization
          .localizations
          .modules
          .home
          .homeView
          .homeButtonTooltip,
      icon: Icon(
        Icons.arrow_back_rounded,
      ),
    );

    final brightnessSwitch = Tooltip(
      message: ModularLocalization
          .localizations
          .modules
          .home
          .homeView
          .brightnessSwitchTooltip,
      child: PortfolioBrightnessSwitch(
        onPressed: () => AppController.instance.toggleThemeMode(),
      ),
    );

    final localeButton = Tooltip(
      message: ModularLocalization
          .localizations
          .modules
          .home
          .homeView
          .localeButtonTooltip,
      child: OverlayOptionsButton(
        initialValue: AppController.instance.locale,
        items: AppController.instance.supportedLocales,
        onChanged: (value) => AppController.instance.locale = value,
        itemBuilder: (context, index, value, select) {
          final assetName = switch (value.languageCode) {
            'pt' => PortfolioIcons.pt,
            'en' => PortfolioIcons.en,
            _ => PortfolioIcons.pt,
          };

          return IconButton(
            onPressed: () => select(),
            icon: SizedBox.square(
              dimension: 24.0,
              child: ClipOval(
                child: SvgPicture.asset(
                  assetName,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );

    final style = TextTheme.of(context).bodyMedium;

    final styleBold = style?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final styleEffect = styleBold?.copyWith(
      color: ColorScheme.of(context).primary,
    );

    final styleLink = style?.copyWith(
      color: ColorScheme.of(context).primary,
      fontStyle: FontStyle.italic,
    );

    final l10n = ModularLocalization.localizations.modules.home.homeView;

    final text = SelectionArea(
      child: Text.rich(
        textAlign: TextAlign.justify,
        TextSpan(
          children: [
            TextSpan(
              style: style,
              children: [
                TextSpan(
                  text: l10n.text0,
                ),
                TextSpan(
                  text: l10n.text1,
                  style: styleBold,
                ),
                TextSpan(
                  text: l10n.text2,
                ),
                TextSpan(
                  text: l10n.text3,
                  style: styleBold,
                ),
                TextSpan(
                  text: l10n.text4,
                ),
                TextSpan(
                  text: l10n.paper,
                  recognizer: paperRecognizer,
                  style: styleLink,
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.text5,
                ),
                TextSpan(
                  text: l10n.effects.pencil,
                  recognizer: pencilRecognizer,
                  style: styleEffect,
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.effects.separator,
                ),
                TextSpan(
                  text: l10n.effects.charcoal,
                  recognizer: charcoalRecognizer,
                  style: styleEffect,
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.effects.separator,
                ),
                TextSpan(
                  text: l10n.effects.woodblock,
                  recognizer: woodblockRecognizer,
                  style: styleEffect,
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.effects.separator,
                ),
                TextSpan(
                  text: l10n.effects.watercolor,
                  recognizer: watercolorRecognizer,
                  style: styleEffect,
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.effects.separator,
                ),
                TextSpan(
                  text: l10n.effects.stippleBrush,
                  // TODO: Restore once the stipple-brush effect is implemented.
                  // recognizer: stippleBrushRecognizer,
                  // style: styleEffect,
                  // mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.effects.lastSeparator,
                ),
                TextSpan(
                  text: l10n.effects.crossHatching,
                  recognizer: crossHatchingRecognizer,
                  style: styleEffect,
                  mouseCursor: SystemMouseCursors.click,
                ),
                TextSpan(
                  text: l10n.text6,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final controls = Card(
      elevation: 8.0,
      color: ColorScheme.of(context).surfaceContainerHigh,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 32.0,
        ),
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (_, _) => FDoGShaderControls(
            settings: widget.controller.settings,
            uploadImage: () => widget.controller.uploadImage(),
            downloadImage: () => widget.controller.downloadImage(),
            draw: () => widget.controller.draw(),
            onSetScale: () => widget.controller.onSetScale(),
            onSetUseColorQuantization: () =>
                widget.controller.onSetUseColorQuantization(),
            onSetUseColorMapping: () =>
                widget.controller.onSetUseColorMapping(),
            onSetUseCrossHatching: () =>
                widget.controller.onSetUseCrossHatching(),
            onSetUseColorBlending: () =>
                widget.controller.onSetUseColorBlending(),
            onSetUsePaperTexture: () =>
                widget.controller.onSetUsePaperTexture(),
            onSetColorMap: (colors) => widget.controller.onSetColorMap(colors),
          ),
        ),
      ),
    );

    final canvas = ListenableBuilder(
      listenable: widget.controller,
      builder: (_, _) {
        final image = widget.controller.image;

        if (image == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final canvasWidth = widget.controller.pipeline.canvas.width.toDouble();
        final canvasHeight = widget.controller.pipeline.canvas.height
            .toDouble();

        final minScale = 0.01;
        final maxScale = 100.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = width * (canvasHeight / canvasWidth);

            final left = FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: canvasWidth,
                height: canvasHeight,
                child: InteractiveViewer(
                  minScale: minScale,
                  maxScale: maxScale,
                  transformationController: transformationController,
                  child: RawImage(
                    key: ValueKey(
                      widget.controller.image.hashCode,
                    ),
                    image: widget.controller.image!,
                    width: widget.controller.image!.width.toDouble(),
                    height: widget.controller.image!.height.toDouble(),
                    fit: BoxFit.contain,
                    isAntiAlias: false,
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ),
            );

            final right = FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: canvasWidth,
                height: canvasHeight,
                child: InteractiveViewer(
                  minScale: minScale,
                  maxScale: maxScale,
                  transformationController: transformationController,
                  child: HtmlElementView(
                    viewType: 'webgl-canvas',
                  ),
                ),
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MouseRegion(
                  onEnter: (_) => isHovering.value = true,
                  onExit: (_) => isHovering.value = false,
                  child: ColoredBox(
                    color: Colors.black,
                    child: ComparisonSlider(
                      width: width,
                      height: height,
                      left: left,
                      right: right,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${canvasWidth}x$canvasHeight'),
                ),
              ],
            );
          },
        );
      },
    );

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final child = width < 600
        ? Column(
            spacing: widget.spacing,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              text,
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height),
                child: controls,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height),
                child: canvas,
              ),
            ],
          )
        : Row(
            spacing: widget.spacing,
            children: [
              Expanded(
                flex: 1,
                child: text,
              ),
              Expanded(
                flex: 2,
                child: controls,
              ),
              Expanded(
                flex: 2,
                child: canvas,
              ),
            ],
          );

    final widthAtViewportEnd = 1200.0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        actions: [
          Expanded(
            child: Center(
              child: PortfolioResponsiveBox(
                widthAtViewportEnd: widthAtViewportEnd,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.spacing,
                  ),
                  child: Row(
                    children: [
                      homeButton,
                      brightnessSwitch,
                      localeButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: isHovering,
        builder: (context, value, child) {
          return SingleChildScrollView(
            physics: isHovering.value ? NeverScrollableScrollPhysics() : null,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(
                  widget.spacing,
                ),
                child: child,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
