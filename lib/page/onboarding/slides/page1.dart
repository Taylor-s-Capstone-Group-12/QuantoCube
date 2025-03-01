import 'package:flutter/material.dart';

class IntroductionPage1 extends StatelessWidget {
  const IntroductionPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Image.asset(
              "assets/introduction/intro_first.png",
              height: 300,
              fit: BoxFit.contain,
              scale: 1,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 200,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 33.0),
              child: Text(
                "Experience the Best Value and Convenience!",
                style: TextStyle(
                  fontSize: 35,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
