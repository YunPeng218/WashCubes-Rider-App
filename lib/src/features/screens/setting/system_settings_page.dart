import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/reset_password_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SystemSettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: CTextTheme.blackTextTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Setting Row Category
            Text('ACCOUNT SETTING', style: CTextTheme.greyTextTheme.labelLarge),
            // Reset Password
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = (prefs.getString('token')) ?? 'No token';
                Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPassword(jwtDecodedToken['email'])),
                );
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reset Password', style: CTextTheme.blackTextTheme.headlineMedium),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.cGreyColor2,),
                ],
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
