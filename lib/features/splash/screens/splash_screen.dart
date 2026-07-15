import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth/screens/login_screen.dart';
import '../../../core/theme/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => const LoginScreen(),
      //   ),
      // );
      Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 800),

    pageBuilder: (_, animation, secondaryAnimation) {
      return const LoginScreen();
    },

    transitionsBuilder: (_, animation, secondaryAnimation, child) {

      return FadeTransition(
        opacity: animation,
        child: child,
      );

    },
  ),
);

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.primary,

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Image.asset(
              "assets/logo/sheshield_logo1.png",
              width: 150,
            ),

            const SizedBox(height: 25),

            const Text(
              "SheShield",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Protection Beyond an SOS.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

          ],

        ),

      ),

    );

  }
}