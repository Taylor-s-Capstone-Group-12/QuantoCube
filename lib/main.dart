import 'package:flutter/material.dart';
import 'package:quantocube/page/onboarding/introduction_page.dart';
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
      home: IntroductionPage(), // ✅ Always starts with IntroductionPage
    );
  }
}
