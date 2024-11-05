import 'package:crispy_fires/colors.dart';
import 'package:flutter/material.dart';

class CrispyButton extends StatelessWidget {
  const CrispyButton({
    super.key,
    this.label,
    this.icon,
    this.isDisabled = false,
    this.onPressed,
    this.background= CrispyColors.bluishGrey
  });

  final String? label;
  final Widget? icon;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (label != null) {
      child = Text(label!);
    } else {
      child = icon!;
    }

    return Opacity(
      opacity: isDisabled ? CrispyColors.disabledOpacity : 1.0,
      child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              ),
              backgroundColor: WidgetStatePropertyAll(background),
              iconSize: const WidgetStatePropertyAll(24.0),
              iconColor: const WidgetStatePropertyAll(CrispyColors.white),
              textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()..color = CrispyColors.white)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)))),
          child: child),
    );
  }
}
