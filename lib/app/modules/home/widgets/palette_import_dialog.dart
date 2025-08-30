import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'palette_widget.dart';

class PaletteImportDialog extends StatefulWidget {
  const PaletteImportDialog({super.key});

  @override
  State<PaletteImportDialog> createState() => _PaletteImportDialogState();
}

class _PaletteImportDialogState extends State<PaletteImportDialog> {
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  late final List<Color> colors;

  Color hex2srgb(String hex) {
    hex = hex.toUpperCase().replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  void refresh() {
    final values = <Color>[];
    final lines = textEditingController.text.split('\n');

    try {
      for (final line in lines) {
        values.add(hex2srgb(line));
      }
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      colors.clear();
      colors.addAll(values);
    });
  }

  @override
  initState() {
    super.initState();

    final n = 4;
    colors = List.generate(
      n,
      (i) {
        final l = i / (n - 1);
        return Color.from(alpha: 1, red: l, green: l, blue: l);
      },
    );

    focusNode.requestFocus();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context).bodyMedium;

    final hintStyle = style?.copyWith(
      color: style.color?.withValues(alpha: 0.5),
      fontStyle: FontStyle.italic,
    );

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
                              'Import Palette',
                              style: TextTheme.of(context).titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            tooltip: 'Close',
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
                        'Import a custom palette by entering hex color values, one per line. You must provide at least two colors for a valid palette.',
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
                      TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onChanged: (value) => refresh(),
                        maxLines: null,
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText:
                              'Enter a list of hex values, one per line, e.g.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF',
                          hintStyle: hintStyle,
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: colors.length < 2 ? null : () => Navigator.of(context).pop(colors),
                            tooltip: 'Accept',
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
