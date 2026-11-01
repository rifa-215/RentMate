import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.home_work_rounded,
                size: 50,
                color: Color(0xFFFF8A00),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'RentMate',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF171717),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Rent What You Need, When You Need It.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 35),

            const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFFF8A00),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
