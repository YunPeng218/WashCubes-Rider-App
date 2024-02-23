import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/homepage/homepage.dart';
import 'package:washcube_rider_app/src/features/screens/login/login_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; //Get Screen Size
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //Align Elements to mid of Column
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(cAppLogo, height: size.height * 0.2), //App Logo
            Text('Rider App', style: CTextTheme.blackTextTheme.displaySmall,), // Rider App Title
            const SizedBox(height: cDefaultSize,), //Spacing
            ListView(
              shrinkWrap: true,//Shrink ListView until Necessary for the Content
              physics: const NeverScrollableScrollPhysics(),
              children: [
                //Login In Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }, 
                  child: Text('Log In', style: CTextTheme.blackTextTheme.headlineMedium,),
                ),
                //Join Button
                OutlinedButton(
                  onPressed: () {
                    // TODO: Head to Rider Vacancy Wedsite
                    //For Now Go Straight to HomePage for Testing Purposes
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }, 
                  child: Text('Join as a Rider', style: CTextTheme.blackTextTheme.headlineMedium,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}