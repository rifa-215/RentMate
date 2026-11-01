import 'package:flutter/material.dart';

import 'screen/splash_screen.dart';

void main() {
  runApp(const RentMateApp());
}

class RentMateApp extends StatelessWidget {
  const RentMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RentMate',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}
