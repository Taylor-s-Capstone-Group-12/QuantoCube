import 'package:flutter/material.dart';

class IntroductionPage2 extends StatelessWidget {
  const IntroductionPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Image.asset(
              "assets/introduction/intro_second.png",
              fit: BoxFit.fitHeight,
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
                "Your Transparent Home Improvement Partner",
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
