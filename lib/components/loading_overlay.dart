import 'package:flutter/material.dart';

/// A widget that shows a loading overlay on top of its child.
/// The overlay is a black screen with a centered circular progress indicator.
/// The overlay is shown when [show] is called and hidden when [hide] is called.
/// The overlay is hidden by default.
class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

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

  void show() {
    setState(() {
      isLoading = true;
    });
  }

  void hide() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(200),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
