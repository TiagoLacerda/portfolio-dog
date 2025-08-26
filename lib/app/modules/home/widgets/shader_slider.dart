import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class ShaderSlider extends StatefulWidget {
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double)? onChanged;

  const ShaderSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.onChanged,
  });

  @override
  State<ShaderSlider> createState() => _ShaderSliderState();
}

class _ShaderSliderState extends State<ShaderSlider> {
  final textEditingController0 = TextEditingController();
  final textEditingController1 = TextEditingController();
  final textEditingController2 = TextEditingController();

  final focusNode0 = FocusNode();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  final throttler = Throttler();

  late double value;
  late double min;
  late double max;

  int decimals = 3;

  /// Listen to changes to the value field and update the other accordingly.
  void valueListener() {
    if (focusNode0.hasFocus) {
      textEditingController0.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController0.text.length,
      );
    } else {
      final number = double.tryParse(textEditingController0.text);

      if (number == null || number == value) {
        textEditingController0.text = value.toStringAsFixed(decimals);
      } else {
        setState(() {
          value = number;
          textEditingController0.text = value.toStringAsFixed(decimals);
          widget.onChanged?.call(value);

          if (min > value) {
            min = value;
            textEditingController1.text = min.toStringAsFixed(decimals);
          }

          if (max < value) {
            max = value;
            textEditingController2.text = max.toStringAsFixed(decimals);
          }
        });
      }
    }
  }

  /// Listen to changes to the min field and update the other accordingly.
  void minListener() {
    if (focusNode1.hasFocus) {
      textEditingController1.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController1.text.length,
      );
    } else {
      final number = double.tryParse(textEditingController1.text);

      if (number == null || number == min) {
        textEditingController1.text = min.toStringAsFixed(decimals);
      } else {
        setState(() {
          min = number;
          textEditingController1.text = min.toStringAsFixed(decimals);

          if (value < min) {
            value = min;
            textEditingController0.text = value.toStringAsFixed(decimals);
            widget.onChanged?.call(value);
          }

          if (max < min) {
            max = min;
            textEditingController2.text = max.toStringAsFixed(decimals);
          }
        });
      }
    }
  }

  /// Listen to changes to the max field and update the other accordingly.
  void maxListener() {
    if (focusNode2.hasFocus) {
      textEditingController2.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController2.text.length,
      );
    } else {
      final number = double.tryParse(textEditingController2.text);

      if (number == null || number == max) {
        textEditingController2.text = max.toStringAsFixed(decimals);
      } else {
        setState(() {
          max = number;
          textEditingController2.text = max.toStringAsFixed(decimals);

          if (value > max) {
            value = max;
            textEditingController0.text = value.toStringAsFixed(decimals);
            widget.onChanged?.call(value);
          }

          if (max < min) {
            min = max;
            textEditingController1.text = min.toStringAsFixed(decimals);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    value = widget.value;
    min = widget.min;
    max = widget.max;

    if (value < min) value = min;
    if (value > max) value = max;
    if (min > max) min = max;
    if (max < min) max = min;

    textEditingController0.text = value.toStringAsFixed(decimals);
    textEditingController1.text = min.toStringAsFixed(decimals);
    textEditingController2.text = max.toStringAsFixed(decimals);

    focusNode0.addListener(valueListener);
    focusNode1.addListener(minListener);
    focusNode2.addListener(maxListener);
  }

  @override
  void didUpdateWidget(covariant ShaderSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    value = widget.value;
    min = widget.min;
    max = widget.max;

    if (value < min) value = min;
    if (value > max) value = max;
    if (min > max) min = max;
    if (max < min) max = min;

    textEditingController0.text = value.toStringAsFixed(decimals);
    textEditingController1.text = min.toStringAsFixed(decimals);
    textEditingController2.text = max.toStringAsFixed(decimals);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController0.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    focusNode0.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
  }

  Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? prefixText,
    double width = 64.0,
    TextAlign textAlign = TextAlign.start,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: textAlign,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;
            return double.tryParse(newValue.text) == null ? oldValue : newValue;
          }),
        ],
        style: TextTheme.of(context).bodyMedium,
        decoration: InputDecoration(
          isDense: true,
          prefixText: prefixText,
          prefixStyle: TextTheme.of(context).bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = Text(
      widget.subtitle,
      style: TextTheme.of(context).bodyMedium?.copyWith(
        color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
        fontSize: 10.0,
        fontWeight: FontWeight.w100,
        fontStyle: FontStyle.italic,
      ),
    );

    final valueTextField = buildTextField(
      context: context,
      controller: textEditingController0,
      focusNode: focusNode0,
      prefixText: '${widget.title}: ',
      width: 128.0,
    );

    final minTextField = buildTextField(
      context: context,
      controller: textEditingController1,
      focusNode: focusNode1,
    );

    final maxTextField = buildTextField(
      context: context,
      controller: textEditingController2,
      focusNode: focusNode2,
      textAlign: TextAlign.end,
    );

    final slider = Slider(
      value: value,
      min: min,
      max: max,
      divisions: widget.divisions,
      onChanged: (value) {
        setState(() => this.value = value);
        textEditingController0.text = value.toStringAsFixed(decimals);

        throttler.throttle(
          duration: const Duration(milliseconds: 1),
          onThrottle: () {
            widget.onChanged?.call(this.value);
          },
        );
      },
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              IgnoreBaseline(child: label),
              valueTextField,
            ],
          ),
        ),
        minTextField,
        Expanded(
          child: slider,
        ),
        maxTextField,
      ],
    );
  }
}
