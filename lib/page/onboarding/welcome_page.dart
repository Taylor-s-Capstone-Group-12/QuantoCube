import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 129.0,
          left: 30.0,
          right: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleGreet(),
            const MascotImage(),
            const SubtitleText(),
            const Spacer(),
            Button(
              onPressed: () {
                // Remove all previous routes so the user
                // can't go back to the welcome page.
                Navigator.pushNamedAndRemoveUntil(
                    context, '/homeowner', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TitleGreet extends StatelessWidget {
  const TitleGreet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Ready\nTo Begin?',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );
  }
}

class MascotImage extends StatelessWidget {
  const MascotImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Transform.translate(
        offset: const Offset(70, 0),
        child: Image.asset(
          height: 300,
          'assets/mascot/homeowner_thumbsup.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  const SubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Text(
        "Welcome to QuantoCube! Tap 'Start' to discover our home improvement services!",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: SizedBox(
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
            child: const Text(
              'Start',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
