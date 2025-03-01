import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/page/auth/auth_selection.dart';
import 'package:quantocube/page/onboarding/slides/page1.dart';
import 'package:quantocube/page/onboarding/slides/page2.dart';
import 'package:quantocube/page/onboarding/slides/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({super.key});

  final PageController _pageController = PageController();

  final List<Widget> _pages = const <Widget>[
    IntroductionPage1(),
    IntroductionPage2(),
    IntroductionPage3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 600,
              child: PageView(
                physics:
                    const NeverScrollableScrollPhysics(), // disable swipe by users
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: _pages,
              ),
            ),
            SizedBox(
              height: 75,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: WormEffect(
                        dotColor: Colors.white,
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                    NextButton(pageController: _pageController, pages: _pages),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.pageController,
    required this.pages,
  });

  final PageController pageController;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (pageController.page == pages.length - 1) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => const AuthSelection(),
            ),
          );
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(54, 54),
        padding: EdgeInsets.zero,
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
