import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/history_page.dart';
import 'package:washcube_rider_app/src/features/screens/profile/edit_profile_page.dart';
import 'package:washcube_rider_app/src/features/screens/setting/system_settings_page.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class LeftNavigationBar extends StatelessWidget {
  const LeftNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.cBarColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            //Account Profile Section
            TextButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RiderEditProfilePage()),
                );}, 
                child: UserAccountsDrawerHeader(
                  accountName: Text("Darren Lee", style: CTextTheme.whiteTextTheme.headlineLarge,),
                  accountEmail: Text("darren9612@gmail.com", style: CTextTheme.greyTextTheme.headlineSmall),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage(cRiderPFP),
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.cBarColor,
                  ),
                ),),
            //Anouncement Tab
            ListTile(
              leading: const Icon(Icons.notifications_none_rounded, color: AppColors.cWhiteColor,),
              title: Text('Announcement', style: CTextTheme.whiteTextTheme.headlineMedium),
              //New Content Chip
              trailing: Chip(
                label: Text('1', style: CTextTheme.whiteTextTheme.headlineSmall),
                backgroundColor: Colors.blue,
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
              },
            ),
            //History Tab
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.cWhiteColor,),
              title: Text('History', style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            //Support Tab
            ListTile(
              leading: const Icon(Icons.headset_mic_outlined, color: AppColors.cWhiteColor,),
              title: Text('Support', style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
            //Settings Tab
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.cWhiteColor,),
              title: Text('Settings', style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SystemSettingsPage()),
                );
              },
            ),
            //Log Out Tab
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.cWhiteColor,),
              title: Text('Log Out', style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}
