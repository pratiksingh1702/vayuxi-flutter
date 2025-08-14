import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, danger }

class CommonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final bool disabled;

  const CommonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.disabled = false,
  });

  Color _getColor() {
    switch (variant) {
      case ButtonVariant.secondary:
        return Colors.grey;
      case ButtonVariant.danger:
        return Colors.red;
      case ButtonVariant.primary:
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getColor(),
          disabledBackgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
