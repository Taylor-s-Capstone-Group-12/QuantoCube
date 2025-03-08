import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quantocube/page/Homeowner/homeowner_homepage.dart';
import 'package:quantocube/page/Homeowner/listing/contractor_profile.dart';
import 'package:quantocube/page/auth/auth_selection.dart';
import 'package:quantocube/page/auth/login_page.dart';
import 'package:quantocube/page/auth/signup/Contractor/contractor_data.dart';
import 'package:quantocube/page/auth/signup/signup_page.dart';
import 'package:quantocube/page/onboarding/introduction_page.dart';
import 'package:quantocube/route/error_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    if (kDebugMode) {
      print('Route: ${settings.name}');
    }

    switch (settings.name) {
      case '/homeowner':
        return CupertinoPageRoute(builder: (_) => const HomeownerHomePage());
      case '/onboarding':
        return CupertinoPageRoute(builder: (_) => IntroductionPage());
      case '/auth':
        return CupertinoPageRoute(builder: (_) => const AuthSelection());
      case '/login':
        return CupertinoPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        // Validation of correct data type
        if (args is bool) {
          return CupertinoPageRoute(
            builder: (_) => SignUpPage(
              isHomeowner: args,
            ),
          );
        }
        // If args is not of the correct type, return an error page.
        return _errorRoute();
      case '/homeowner/contractor_page':
        // Validation of correct data type
        if (args is ContractorData) {
          return CupertinoPageRoute(
            builder: (_) => ContractorProfile(
              contractor: args,
            ),
          );
        } else {
          return _errorRoute();
        }
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (_) => const ErrorPage(),
    );
  }
}
