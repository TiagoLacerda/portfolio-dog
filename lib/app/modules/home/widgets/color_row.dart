import 'package:flutter/material.dart';

class ColorRow extends StatefulWidget {
  final List<Color> colors;
  final double size;
  final double spacing;

  const ColorRow({
    super.key,
    this.colors = const [],
    this.size = 24.0,
    this.spacing = 2.0,
  });

  @override
  State<ColorRow> createState() => _ColorRowState();
}

class _ColorRowState extends State<ColorRow> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          vertical: 8.0 + 2.0 * widget.spacing,
        ),
        child: Row(
          children: [
            for (int i = 0; i < widget.colors.length; ++i) ...[
              Container(
                width: widget.size,
                height: widget.size,
                margin: EdgeInsets.only(
                  right: i < widget.colors.length - 1 ? widget.spacing : 0.0,
                ),
                decoration: BoxDecoration(
                  color: widget.colors[i],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
