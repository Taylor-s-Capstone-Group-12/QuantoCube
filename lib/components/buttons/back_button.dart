import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back),
          SizedBox(width: 5),
          Text(
            'Back',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class CircularBackButton extends StatelessWidget {
  const CircularBackButton({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 50,
      height: height ?? 50,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
          weight: 500,
        ),
      ),
    );
  }
}
