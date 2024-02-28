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
  bool autoReceiveOrder = false;
  bool receivePickUpAlerts = true;

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
            // Notification Category
            Text('NOTIFICATION', style: CTextTheme.greyTextTheme.labelLarge),
            // Auto Order Retrieval Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Auto receive order', style: CTextTheme.blackTextTheme.headlineMedium),
                //TODO: Stand in Switch condition
                Switch(
                  value: autoReceiveOrder,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    setState(() {
                      autoReceiveOrder = value;
                    });
                  },
                ),
              ],
            ),
            // Pick Up Alert Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receive pick up alerts', style: CTextTheme.blackTextTheme.headlineMedium),
                Switch(
                  value: receivePickUpAlerts,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    setState(() {
                      receivePickUpAlerts = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize),
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
            
            const SizedBox(height: cDefaultSize),
            // Delete Account Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Delete Account',
                      style: CTextTheme.blackTextTheme.headlineMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
