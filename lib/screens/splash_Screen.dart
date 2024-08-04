import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:sm/responsive_layout/mobile_screen.dart';
import 'package:sm/responsive_layout/responsive_layout_screen.dart';
import 'package:sm/responsive_layout/web_screen.dart';
import 'package:sm/screens/login_screen.dart';
import 'package:sm/utils/colors.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        backgroundColor: mobileBackgroundColor,
        splash: Column(
          children: [
            Lottie.asset(
              'assets/animation/anm.json',
            ),
            const Text(
              " M E M O R I E S ",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        nextScreen: (_auth.currentUser != null)
            ? const ResponsiveLayoutScreen(
                mobileScreenlayout: MobileScreenLayout(),
                webScreenlayout: WebScreenlayout())
            : const LoginScreen(),
        duration: 200,
        splashIconSize: 400);
  }
}
