import 'package:flutter/material.dart';

/// A widget that shows a loading overlay on top of its child.
/// The overlay is a black screen with a centered circular progress indicator.
/// The overlay is shown when [show] is called and hidden when [hide] is called.
/// The overlay is hidden by default.
/// Access the methods by calling [LoadingOverlay.of(context)].
class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    this.color,
    this.alpha,
  }) : assert(color == null || alpha == null,
            "Only provide a color or an alpha value, not both. If alpha values must be directly added to the color value through the Color.withAlpha() method.");

  /// The widget to show the overlay on top of.
  final Widget child;

  /// The color of the overlay. Default is black.
  /// If a color is provided, the alpha value must be null.
  final Color? color;

  /// The alpha value of the overlay color. Value must be between 0 and 255.
  ///  Default is 200.
  final int? alpha;

  static LoadingOverlayState of(BuildContext context) {
    final state = context.findAncestorStateOfType<LoadingOverlayState>();
    if (state == null) {
      throw Exception("No LoadingOverlay found in context");
    }
    return state;
  }

  @override
  State<LoadingOverlay> createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay> {
  bool isLoading = false;

  /// Show the loading overlay.
  void show() {
    setState(() {
      isLoading = true;
    });
  }

  /// Hide the loading overlay.
  void hide() {
    setState(() {
      isLoading = false;
    });
  }

  /// Get the color of the overlay based on the provided color or alpha value.
  Color colorSetter() {
    if (widget.color != null) {
      return widget.color!;
    } else {
      return Colors.black.withAlpha(widget.alpha ?? 200);
    }
  }

  /// Get the color of the overlay.
  Color get overlayColor => colorSetter();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
