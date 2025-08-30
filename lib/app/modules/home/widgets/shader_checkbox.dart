import 'package:flutter/material.dart';

class ShaderCheckbox extends StatefulWidget {
  final String subtitle;
  final bool? initialValue;
  final bool enabled;
  final void Function(bool)? onChanged;

  const ShaderCheckbox({
    super.key,
    required this.subtitle,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
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
    return Row(
      children: [
        SizedBox(
          width: 128.0,
          child: Text(
            widget.subtitle,
            style: TextTheme.of(context).bodyMedium?.copyWith(
              color: TextTheme.of(context).bodyMedium?.color?.withValues(alpha: 0.5),
              fontSize: 10.0,
              fontWeight: FontWeight.w100,
              fontStyle: FontStyle.italic,
            ),
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
      ],
    );
  }
}
