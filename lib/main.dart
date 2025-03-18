import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quantocube/page/messaging/main/message_page.dart';
import 'package:quantocube/page/onboarding/introduction_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:quantocube/page/homeowner/listing/service_request_page.dart';
import 'package:quantocube/page/messaging/chat_list_page.dart';
import 'package:quantocube/page/onboarding/splash_screen.dart';
import 'package:quantocube/tests/sample_classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:quantocube/page/auth/signup/signup_address_page.dart';
import 'firebase_options.dart'; // Ensure this file exists (Generated by `flutterfire configure`)
import 'package:quantocube/route/route_generator.dart';
import 'package:quantocube/theme.dart';

import 'package:quantocube/page/homeowner/listing/contractor_profile_page.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // Prevent the app from rotating to landscape mode
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Reset shared preferences
  // resetSharedPreferences();

  runApp(const MyApp());
}

void resetSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ProjectTheme.theme,
      // home: MessagePage(
      //   projectId: '123',
      //   isFirstTime: true,
      // ),
      home: const SplashScreen(),
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
