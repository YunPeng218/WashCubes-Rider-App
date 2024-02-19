import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/features/screens/welcome/welcome_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CAppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
