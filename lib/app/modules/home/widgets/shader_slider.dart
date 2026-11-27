import 'dart:developer';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class ShaderSlider<T extends num> extends StatefulWidget {
  final String title;
  final String subtitle;
  final T value;
  final T min;
  final T max;
  final int? Function(T, T) getDivisions;
  final int decimals;
  final bool enabled;
  final void Function(T)? onChanged;
  final void Function(T min, T max)? onChangedRange;

  const ShaderSlider({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.getDivisions = _getDivisions,
    this.decimals = 3,
    this.enabled = true,
    this.onChanged,
    this.onChangedRange,
  });

  static int? _getDivisions(_, _) => null;

  @override
  State<ShaderSlider<T>> createState() => _ShaderSliderState<T>();
}

class _ShaderSliderState<T extends num> extends State<ShaderSlider<T>> {
  final textEditingController0 = TextEditingController();
  final textEditingController1 = TextEditingController();
  final textEditingController2 = TextEditingController();

  final focusNode0 = FocusNode();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  final throttler = Throttler();

  late T value;
  late T min;
  late T max;

  T? tryParse(String source) {
    if (T == int) {
      return int.tryParse(source) as T?;
    }

    if (T == double) {
      return double.tryParse(source) as T?;
    }

    log('Unsupported numeric type: $T. Will return null.');

    return null;
  }

  /// Listen to changes to the value field and update the other accordingly.
  void valueListener() {
    if (focusNode0.hasFocus) {
      textEditingController0.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController0.text.length,
      );
    } else {
      final number = tryParse(textEditingController0.text);

      if (number == null || number == value) {
        textEditingController0.text = value.toStringAsFixed(widget.decimals);
      } else {
        setState(() {
          value = number;
          textEditingController0.text = value.toStringAsFixed(widget.decimals);

          if (min > value) {
            min = value;
            textEditingController1.text = min.toStringAsFixed(widget.decimals);
          }

          if (max < value) {
            max = value;
            textEditingController2.text = max.toStringAsFixed(widget.decimals);
          }

          widget.onChangedRange?.call(min, max);
          widget.onChanged?.call(value);
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
      final number = tryParse(textEditingController1.text);

      if (number == null || number == min) {
        textEditingController1.text = min.toStringAsFixed(widget.decimals);
      } else {
        setState(() {
          min = number;
          textEditingController1.text = min.toStringAsFixed(widget.decimals);

          if (max < min) {
            max = min;
            textEditingController2.text = max.toStringAsFixed(widget.decimals);
          }

          widget.onChangedRange?.call(min, max);

          if (value < min) {
            value = min;
            textEditingController0.text = value.toStringAsFixed(
              widget.decimals,
            );
            widget.onChanged?.call(value);
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
      final number = tryParse(textEditingController2.text);

      if (number == null || number == max) {
        textEditingController2.text = max.toStringAsFixed(widget.decimals);
      } else {
        setState(() {
          max = number;
          textEditingController2.text = max.toStringAsFixed(widget.decimals);

          if (max < min) {
            min = max;
            textEditingController1.text = min.toStringAsFixed(widget.decimals);
          }

          widget.onChangedRange?.call(min, max);

          if (value > max) {
            value = max;
            textEditingController0.text = value.toStringAsFixed(
              widget.decimals,
            );
            widget.onChanged?.call(value);
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

    if (value < min) min = value;
    if (value > max) max = value;
    if (min != widget.min || max != widget.max) widget.onChangedRange?.call(min, max);

    textEditingController0.text = value.toStringAsFixed(widget.decimals);
    textEditingController1.text = min.toStringAsFixed(widget.decimals);
    textEditingController2.text = max.toStringAsFixed(widget.decimals);

    focusNode0.addListener(valueListener);
    focusNode1.addListener(minListener);
    focusNode2.addListener(maxListener);
  }

  @override
  void didUpdateWidget(ShaderSlider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    value = widget.value;
    min = widget.min;
    max = widget.max;

    if (value < min) min = value;
    if (value > max) max = value;
    if (min != widget.min || max != widget.max) widget.onChangedRange?.call(min, max);

    textEditingController0.text = value.toStringAsFixed(widget.decimals);
    textEditingController1.text = min.toStringAsFixed(widget.decimals);
    textEditingController2.text = max.toStringAsFixed(widget.decimals);
  }

  @override
  void dispose() {
    textEditingController0.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    focusNode0.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? prefixText,
    double width = 64.0,
    TextAlign textAlign = TextAlign.start,
  }) {
    final style = TextTheme.of(context).bodyMedium?.copyWith(
      color: TextTheme.of(context).bodyMedium?.color?.withValues(
        alpha: widget.enabled ? 1.0 : 0.5,
      ),
    );

    final prefixStyle = style?.copyWith(
      fontStyle: FontStyle.italic,
    );

    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: textAlign,
        keyboardType: TextInputType.number,
        enabled: widget.enabled,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;
            return tryParse(newValue.text) == null ? oldValue : newValue;
          }),
        ],
        style: style,
        decoration: InputDecoration(
          isDense: true,
          prefixText: prefixText,
          prefixStyle: prefixStyle,
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
      value: value.toDouble(),
      min: min.toDouble(),
      max: max.toDouble(),
      divisions: widget.getDivisions(min, max),
      onChanged: widget.enabled
          ? (value) {
              final T t = (T == int ? value.toInt() : value) as T;

              setState(() {
                this.value = t;
              });

              textEditingController0.text = value.toStringAsFixed(
                widget.decimals,
              );
              throttler.throttle(
                duration: const Duration(milliseconds: 1),
                onThrottle: () {
                  widget.onChanged?.call(t);
                },
              );
            }
          : null,
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
