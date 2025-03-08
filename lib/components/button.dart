import 'package:flutter/material.dart';

class LargeOrangeButton extends StatelessWidget {
  const LargeOrangeButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
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
  }) {
    final Widget child = Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Colors.white,
      ),
    );

    return LargeOrangeButton(
      key: key,
      onPressed: onPressed,
      child: child,
    );
  }
}
