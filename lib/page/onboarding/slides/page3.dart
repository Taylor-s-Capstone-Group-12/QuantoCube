import 'package:flutter/material.dart';

class IntroductionPage3 extends StatelessWidget {
  const IntroductionPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Image.asset(
              "assets/introduction/intro_third.png",
              fit: BoxFit.fitHeight,
              height: 400,
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
                "Your Home,\nYour Way with QuantoCube!",
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
