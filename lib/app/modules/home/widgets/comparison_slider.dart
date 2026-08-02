import 'package:flutter/material.dart';

class ComparisonSlider extends StatefulWidget {
  final double width;
  final double height;
  final Widget left;
  final Widget right;

  const ComparisonSlider({
    super.key,
    required this.width,
    required this.height,
    required this.left,
    required this.right,
  });

  @override
  State<ComparisonSlider> createState() => _ComparisonSliderState();
}

class _ComparisonSliderState extends State<ComparisonSlider> {
  double _position = 0.5;

  @override
  Widget build(BuildContext context) {
    final iconSize = 32.0;
    final dragHandleSize = 40.0;
    final dividerX = widget.width * _position;
    final dividerWidth = 3.0;
    final dividerColor = Colors.white;
    final divider = Container(
      width: dividerWidth,
      height: (widget.height - dragHandleSize) * 0.5,
      color: dividerColor,
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) {
          setState(() {
            _position = (_position + details.delta.dx / widget.width).clamp(0.0, 1.0);
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              clipper: _ComparisonSliderCustomClipper.right(
                _position,
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.right,
            ),
            ClipRect(
              clipper: _ComparisonSliderCustomClipper.left(
                _position,
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.left,
            ),
            Positioned(
              left: dividerX - dividerWidth * 0.5,
              top: 0,
              child: divider,
            ),
            Positioned(
              left: dividerX - dividerWidth * 0.5,
              bottom: 0,
              child: divider,
            ),
            Positioned(
              left: dividerX - dragHandleSize * 0.5,
              top: (widget.height - dragHandleSize) * 0.5,
              child: Container(
                width: dragHandleSize,
                height: dragHandleSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dividerColor,
                    width: dividerWidth,
                  ),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.5,
                        child: Icon(
                          Icons.arrow_left,
                          size: iconSize,
                        ),
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Icon(
                          Icons.arrow_right,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonSliderCustomClipper extends CustomClipper<Rect> {
  final double x;
  final bool isLeftSide;

  _ComparisonSliderCustomClipper.left(this.x) : isLeftSide = true;
  _ComparisonSliderCustomClipper.right(this.x) : isLeftSide = false;

  @override
  Rect getClip(Size size) {
    final l = isLeftSide ? 0.0 : size.width * x;
    final t = 0.0;
    final w = isLeftSide ? size.width * x : size.width * (1.0 - x);
    final h = size.height;

    return Rect.fromLTWH(l, t, w, h);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}
