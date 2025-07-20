import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'screens/welcome_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/monitor_screen.dart';

void main() {
  runApp(const RobotScraperApp());
}

class RobotScraperApp extends StatelessWidget {
  const RobotScraperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Scraper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: const WelcomeScreen(), 
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signup':
            return PageTransition(
              child: const SignUpScreen(),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          case '/login':
            return PageTransition(
              child: const LoginScreen(),
              type: PageTransitionType.leftToRight,
              settings: settings,
            );
          case '/home':
            return PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.scale,
              alignment: Alignment.center,
              settings: settings,
            );
          case '/schedule':
            return PageTransition(
              child: const ScheduleScreen(),
              type: PageTransitionType.rightToLeftWithFade,
              settings: settings,
            );
          case '/monitor':
            return PageTransition(
              child: const MonitorScreen(),
              type: PageTransitionType.leftToRightWithFade,
              settings: settings,
            );
          default:
            return null;
        }
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }
}