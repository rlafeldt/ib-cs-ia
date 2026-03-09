import 'package:app_cs/services/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      body: Column(
        children: [
          Image.asset(
              '/Users/raphaellafeldt/VScodeprojects/app_cs/lib/assets/images/p_icon.png'),
          const SizedBox(height: 64),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
