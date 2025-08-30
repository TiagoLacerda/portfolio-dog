import 'package:flutter/material.dart';

class ShaderCheckbox extends StatefulWidget {
  final String? prefixText;
  final String? title;
  final String subtitle;
  final bool? initialValue;
  final bool enabled;
  final void Function(bool)? onChanged;
  final Widget? trailing;

  const ShaderCheckbox({
    super.key,
    this.prefixText,
    this.title,
    required this.subtitle,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.trailing,
  });

  @override
  State<ShaderCheckbox> createState() => _ShaderCheckboxState();
}

class _ShaderCheckboxState extends State<ShaderCheckbox> {
  bool value = false;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    value = widget.initialValue ?? value;
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context).bodyMedium?.copyWith(
      color: TextTheme.of(context).bodyMedium?.color?.withValues(
        alpha: widget.enabled ? 1.0 : 0.5,
      ),
    );

    final prefixStyle = style?.copyWith(
      fontStyle: FontStyle.italic,
    );

    return Row(
      children: [
        SizedBox(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.subtitle,
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w100,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (widget.prefixText != null || widget.title != null)
                RichText(
                  text: TextSpan(
                    children: [
                      if (widget.prefixText != null)
                        TextSpan(
                          text: widget.prefixText,
                          style: prefixStyle,
                        ),
                      if (widget.title != null)
                        TextSpan(
                          text: widget.title,
                          style: style,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Checkbox(
              value: widget.enabled ? value : false,
              onChanged: widget.enabled
                  ? (value) {
                      setState(() => this.value = value!);
                      widget.onChanged?.call(this.value);
                    }
                  : null,
            );
          },
        ),
        if (widget.trailing != null) widget.trailing!,
      ],
    );
  }
}
