import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_options_button/overlay_options_button.dart';
import 'package:portfolio_design_system/portfolio_design_system.dart';

import '../../../l10n/generated/modular_localization.dart';
import '../../app_controller.dart';
import 'home_controller.dart';
import 'widgets/shader_controls.dart';

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

  final isHovering = ValueNotifier<bool>(false);

  @override
  void dispose() {
    scrollController.dispose();
    isHovering.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightnessSwitch = PortfolioBrightnessSwitch(
      onPressed: () => AppController.instance.toggleThemeMode(),
    );

    final localeButton = OverlayOptionsButton(
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
    );

    final style = TextTheme.of(context).bodyMedium;

    final styleBold = style?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final text = SelectionArea(
      child: Text.rich(
        textAlign: TextAlign.justify,
        TextSpan(
          children: [
            TextSpan(
              style: style,
              children: [
                TextSpan(
                  text: ModularLocalization.localizations.modules.home.homeView.text0,
                ),
                TextSpan(
                  text: ModularLocalization.localizations.modules.home.homeView.text1,
                  style: styleBold,
                ),
                TextSpan(
                  text: ModularLocalization.localizations.modules.home.homeView.text2,
                ),
                TextSpan(
                  text: ModularLocalization.localizations.modules.home.homeView.text3,
                ),
                TextSpan(
                  text: ModularLocalization.localizations.modules.home.homeView.text4,
                  style: styleBold,
                ),
                TextSpan(
                  text: ModularLocalization.localizations.modules.home.homeView.text5,
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
        child: ShaderControls(
          key: widget.controller.shaderControls,
          pipeline: widget.controller.pipeline,
          onSetScale: () => widget.controller.onSetScale(),
        ),
      ),
    );

    final canvas = ListenableBuilder(
      listenable: widget.controller,
      builder: (_, _) {
        final width = widget.controller.pipeline.canvas.width.toDouble();
        final height = widget.controller.pipeline.canvas.height.toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MouseRegion(
              onEnter: (_) => isHovering.value = true,
              onExit: (_) => isHovering.value = false,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: ColoredBox(
                    color: Colors.black,
                    child: InteractiveViewer(
                      minScale: 0.01,
                      maxScale: 100.0,
                      child: HtmlElementView(
                        viewType: 'webgl-canvas',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text('${width}x$height'),
            ),
          ],
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
                flex: 1,
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
              child: PortfolioResponsiveBox(
                widthAtViewportEnd: widthAtViewportEnd,
                child: Padding(
                  padding: EdgeInsets.all(
                    widget.spacing,
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
