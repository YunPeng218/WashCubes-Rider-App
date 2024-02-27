import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/id_rider/id_verification_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class RiderEditProfilePage extends StatefulWidget {
  const RiderEditProfilePage({super.key});

  @override
  _RiderEditProfilePageState createState() => _RiderEditProfilePageState();
}

class _RiderEditProfilePageState extends State<RiderEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: CTextTheme.blackTextTheme.displayLarge),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code, color: AppColors.cBlackColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IDVerificationScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ListView(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 10),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(cRiderPFP),
                      ),
                    ),
                  ),
                  //Camera PFP Icon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: AppColors.cGreyColor1,
                        ),
                        color: AppColors.cGreyColor1,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: AppColors.cBlueColor3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            //TODO: Implement Edit Function Here
            //Name Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREFERRED NAME',
                  style: CTextTheme.greyTextTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Darren Lee',
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.cGreyColor2),
                      onPressed: () {
                        // showEditDialog(context, widget.title, widget.value);
                      },
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
            //Mobile Number Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MOBILE NUMBER',
                  style: CTextTheme.greyTextTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+60 19-906 0912',
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.cGreyColor2),
                      onPressed: () {
                        // showEditDialog(context, widget.title, widget.value);
                      },
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
            //Email Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EMAIL ADDRESS',
                  style: CTextTheme.greyTextTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'darren9612@gmail.com',
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.cGreyColor2),
                      onPressed: () {
                        // showEditDialog(context, widget.title, widget.value);
                      },
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
            // buildTextField("PREFERRED NAME", "Darren Lee", false),
            // buildTextField("MOBILE NUMBER", "+60 19-906 0912", false),
            // buildTextField("EMAIL ADDRESS", "darren9612@gmail.com", false),
          ],
        ),
      ),
    );
  }

  // Widget buildTextField(String labelText, String placeholder, bool isPasswordTextField) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 35.0),
  //     child: TextField(
  //       enabled: false,
  //       decoration: InputDecoration(
  //         contentPadding: EdgeInsets.only(bottom: 3),
  //         labelText: labelText,
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         hintText: placeholder,
  //         hintStyle: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
