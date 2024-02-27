import 'dart:async';

import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/login/login_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class PasswordUpdatedScreen extends StatefulWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  State<PasswordUpdatedScreen> createState() => _PasswordUpdatedScreenState();

}
class _PasswordUpdatedScreenState extends State<PasswordUpdatedScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer to auto navigate back to homepage after preset time
    Timer(const Duration(seconds: 3), () {
      // Use pushReplacement to replace the current screen with the homepage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Image.asset(cDoubleCheckmark),
              Text(
                'Password Updated!',
                style: CTextTheme.blackTextTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
