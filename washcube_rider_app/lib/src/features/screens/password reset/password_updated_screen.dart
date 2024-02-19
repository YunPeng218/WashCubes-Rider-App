import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/login/login_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

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
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text('Continue', style: CTextTheme.blackTextTheme.headlineMedium,)),
            ],
          ),
        ),
      ),
    );
  }
}
