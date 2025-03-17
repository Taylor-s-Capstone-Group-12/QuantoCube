import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/page/homeowner/homeowner_homepage.dart';
import 'package:quantocube/page/homeowner/listing/contractor_profile.dart';
import 'package:quantocube/page/homeowner/listing/contractor_profile_page.dart';
import 'package:quantocube/page/auth/auth_selection.dart';
import 'package:quantocube/page/auth/login_page.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/page/auth/signup/signup_page.dart';
import 'package:quantocube/page/messaging/chat_list_page.dart';
import 'package:quantocube/page/onboarding/introduction_page.dart';
import 'package:quantocube/page/search/geo_search.dart';
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
        if (args is ContractorPageArgs) {
          return CupertinoPageRoute(
            builder: (_) => ContractorProfile(
              contractor: args.contractor,
              reviews: args.reviews,
            ),
          );
        } else {
          return _errorRoute();
        }
      case '/geo_search':
        return CupertinoPageRoute(builder: (_) => GeoSearchPage());
      case '/homeowner/contractor_profile_page':
        if (args is String) {
          return CupertinoPageRoute(
            builder: (_) => ContractorProfilePage(contractorId: args),
          );
        }
        return _errorRoute();
      case '/messaging':
        return CupertinoPageRoute(builder: (_) => const ChatListPage());
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
