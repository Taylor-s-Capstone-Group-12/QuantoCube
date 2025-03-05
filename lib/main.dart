import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quantocube/page/auth/signup/name_setup_page.dart';
import 'package:quantocube/page/onboarding/introduction_page.dart';
import 'package:quantocube/page/onboarding/welcome_page.dart';
import 'package:quantocube/route/error_page.dart';
import 'package:quantocube/route/route_generator.dart';
import 'package:quantocube/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: projectTheme,
      home: IntroductionPage(),
      navigatorObservers: [
        KeyboardDismissNavigatorObserver(),
      ],
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

// Collapse the keyboard whenever a new page is opened
class KeyboardDismissNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
    super.didPop(route, previousRoute);
  }
}
