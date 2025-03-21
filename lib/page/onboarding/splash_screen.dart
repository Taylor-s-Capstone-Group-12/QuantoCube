import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool? hasSeenOnboarding;

  @override
  void initState() {
    checkInitialRoute();
    controller = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..initialize().then((_) {
        controller.play(); // auto-play video
        controller.setLooping(false); // do not loop video
        setState(() {}); // refresh UI once video is loaded
      });
    controller.addListener(() {
      if (controller.value.position >= controller.value.duration) {
        _navigaTetoNextScreen();
      }
    });

    _initializeVideoPlayerFuture = controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

// Check if the user has receive the onboarding screen
// If not, show the onboarding screen
// If yes, show the home screen
  Future<void> checkInitialRoute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');
    if (hasSeenOnboarding == null || hasSeenOnboarding == false) {
      prefs.setBool('hasSeenOnboarding', true);
    }
    this.hasSeenOnboarding = hasSeenOnboarding;
  }

  void _navigaTetoNextScreen() {
    String destination = '/onboarding';

    if (hasSeenOnboarding ?? false) {
      destination = '/auth';
    }
    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 6, 8),
      body: Center(
        child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }), // show empty screen before the video is loaded
      ),
    );
  }
}
