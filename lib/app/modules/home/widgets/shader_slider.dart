import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.onChanged,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
  });

  @override
  State<ShaderSlider> createState() => _ShaderSliderState();
}

class _ShaderSliderState extends State<ShaderSlider> {
  final textEditingController0 = TextEditingController();
  final textEditingController1 = TextEditingController();
  final focusNode0 = FocusNode();
  final focusNode1 = FocusNode();

  late double value;
  late double min;
  late double max;

  int decimals = 3;

  @override
  void initState() {
    super.initState();

    value = widget.value;
    min = widget.min;
    max = widget.max;

    textEditingController0.text = min.toStringAsFixed(decimals);
    textEditingController1.text = max.toStringAsFixed(decimals);

    focusNode0.addListener(() {
      if (focusNode0.hasFocus) {
        textEditingController0.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textEditingController0.text.length,
        );
      } else {
        final newValue = double.tryParse(textEditingController0.text);

        if (newValue == null || newValue == min) {
          textEditingController0.text = min.toStringAsFixed(decimals);
          return;
        }

        setState(() {
          min = newValue;
          textEditingController0.text = min.toStringAsFixed(decimals);

          if (max < min) {
            max = min;
            textEditingController1.text = max.toStringAsFixed(decimals);
          }

          if (value < min) {
            value = min;
            widget.onChanged?.call(value);
          }
        });
      }
    });

    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        textEditingController1.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textEditingController1.text.length,
        );
      } else {
        final newValue = double.tryParse(textEditingController1.text);

        if (newValue == null || newValue == max) {
          textEditingController1.text = max.toStringAsFixed(decimals);
          return;
        }

        setState(() {
          max = newValue;
          textEditingController1.text = max.toStringAsFixed(decimals);

          if (max < min) {
            min = max;
            textEditingController0.text = min.toStringAsFixed(decimals);
          }

          if (value > max) {
            value = max;
            widget.onChanged?.call(value);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController0.dispose();
    textEditingController1.dispose();
    focusNode0.dispose();
    focusNode1.dispose();
  }

  Widget buildTextField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return SizedBox(
      width: 64.0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;
            return double.tryParse(newValue.text) == null ? oldValue : newValue;
          }),
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = SizedBox(
      width: 128.0,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: RichText(
          maxLines: 2,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${widget.subtitle}\n',
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w100,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: '${widget.title}:  ',
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: value.toStringAsFixed(decimals),
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final minTextField = buildTextField(
      context,
      textEditingController0,
      focusNode0,
    );

    final maxTextField = buildTextField(
      context,
      textEditingController1,
      focusNode1,
    );

    final slider = Slider(
      value: value,
      min: min,
      max: max,
      divisions: widget.divisions,
      onChanged: (value) {
        setState(() => this.value = value);
        widget.onChanged?.call(this.value);
      },
    );

    return Row(
      children: [
        label,
        minTextField,
        Expanded(
          child: slider,
        ),
        maxTextField,
      ],
    );
  }
}
