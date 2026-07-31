import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/modular_localization.dart';
import '../../../core/adapters/oklab/oklab.dart';
import 'palette_widget.dart';

class PaletteGenerateDialog extends StatefulWidget {
  const PaletteGenerateDialog({super.key});

  @override
  State<PaletteGenerateDialog> createState() => _PaletteGenerateDialogState();
}

class _PaletteGenerateDialogState extends State<PaletteGenerateDialog> {
  late final List<Color> colors;

  final rng = Random();

  double l = 0.0;
  double a = 0.0;
  double b = 0.0;

  void refresh() {
    final l = 1.0 / (colors.length - 1.0);

    setState(() {
      for (int i = 0; i < colors.length; ++i) {
        colors[i] = Oklab.lab2srgb(l * i, a, b);
      }
    });
  }

  @override
  initState() {
    super.initState();

    final n = 8;
    colors = List.generate(
      n,
      (i) {
        final l = i / (n - 1);
        return Color.from(alpha: 1, red: l, green: l, blue: l);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4.0,
              sigmaY: 4.0,
            ),
            child: Dialog(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(
                  16.0,
                ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 400.0,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.title,
                              style: TextTheme.of(context).titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          IconButton(
                            onPressed: () => context.pop(),
                            tooltip: ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.close,
                            icon: Icon(
                              Icons.close_rounded,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.body0,
                        style: TextTheme.of(context).bodyMedium,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.body1,
                        style: TextTheme.of(context).bodyMedium,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Center(
                        child: PaletteWidget(
                          colors: colors,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: a,
                              min: -0.5,
                              max: 0.5,
                              onChanged: (value) {
                                a = value;
                                refresh();
                              },
                            ),
                          ),
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: b,
                              min: -0.5,
                              max: 0.5,
                              onChanged: (value) {
                                b = value;
                                refresh();
                              },
                            ),
                          ),
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              a = rng.nextDouble() - 0.5;
                              b = rng.nextDouble() - 0.5;
                              refresh();
                            },
                            tooltip:
                                ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.random,
                            icon: Icon(
                              Icons.shuffle_rounded,
                            ),
                          ),
                          IconButton(
                            onPressed: colors.length < 3
                                ? null
                                : () {
                                    colors.removeLast();
                                    refresh();
                                  },
                            tooltip:
                                ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.decrease,
                            icon: Icon(
                              Icons.remove_circle_outline_rounded,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              colors.add(Colors.white);
                              refresh();
                            },
                            tooltip:
                                ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.increase,
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.pop(colors),
                            tooltip:
                                ModularLocalization.localizations.modules.home.widgets.paletteGenerateDialog.accept,
                            icon: Icon(
                              Icons.check_circle_outline_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
