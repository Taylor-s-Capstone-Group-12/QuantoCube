import 'package:flutter/material.dart';

class DefaultSquareButton extends StatelessWidget {
  const DefaultSquareButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: child,
      ),
    );
  }

  static Widget onlyText(
    BuildContext context, {
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    double? fontSize,
    double? height,
  }) {
    final Widget child = Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: Colors.white,
      ),
    );

    return DefaultSquareButton(
      key: key,
      onPressed: onPressed,
      height: height,
      child: child,
    );
  }
}
