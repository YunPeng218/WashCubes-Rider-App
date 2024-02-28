import 'package:flutter/material.dart';
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
                // FutureBuilder<bool>(
                //   future: isNotificationEnabled(),
                //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const CircularProgressIndicator();
                //     } else if (snapshot.hasError) {
                //       return const Text('Error loading notification status');
                //     } else {
                //       return Switch(
                //         value: snapshot.data ?? false,
                //         activeColor: AppColors.cSwitchColor,
                //         onChanged: (bool value) async {
                //           if (value==true) {
                //             SharedPreferences prefs = await SharedPreferences.getInstance();
                //             var token = prefs.getString('token');
                //             Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
                //             var reqUrl = '${url}addFCMToken';
                //             http.patch(Uri.parse(reqUrl),
                //               body: {"userId": jwtDecodedToken['_id'], "fcmToken": prefs.getString('fcmToken')});
                //             await prefs.setString('isNotificationEnabled', 'true');
                //           } else {
                //             SharedPreferences prefs = await SharedPreferences.getInstance();
                //             var token = prefs.getString('token');
                //             Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
                //             var reqUrl = '${url}deleteFCMToken';
                //             http.patch(Uri.parse(reqUrl),
                //               body: {"userId": jwtDecodedToken['_id'], "fcmToken": prefs.getString('fcmToken')});
                //             await prefs.setString('isNotificationEnabled', 'false');
                //           }
                //           setState(() {
                //             orderstatuslight = value;
                //           });
                //         },
                //       );
                //     }
                //   },
                // ),
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
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResetPassword()),
                );
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reset Password', style: CTextTheme.blackTextTheme.headlineMedium),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.cGreyColor2,),
                  // FutureBuilder<bool>(
                  //   future: isBiometricsEnabled(),
                  //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return const Text('Error loading biometric status');
                  //     } else {
                  //       return Switch(
                  //         value: snapshot.data ?? false,
                  //         activeColor: AppColors.cSwitchColor,
                  //         onChanged: (bool value) async {
                  //           if (value==true) {
                  //             checkBiometrics(context);
                  //           } else {
                  //             SharedPreferences prefs = await SharedPreferences.getInstance();
                  //             await prefs.setString('isBiometricsEnabled', 'false');
                  //           }
                  //           setState(() {
                  //             biometriclight = value;
                  //           });
                  //         },
                  //       );
                  //     }
                  //   },
                  // ),
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
