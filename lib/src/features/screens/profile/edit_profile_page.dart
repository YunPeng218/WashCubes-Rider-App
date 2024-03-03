import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/archive/id_rider/id_verification_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;

class RiderEditProfilePage extends StatefulWidget {
  const RiderEditProfilePage({super.key});

  @override
  _RiderEditProfilePageState createState() => _RiderEditProfilePageState();
}

class _RiderEditProfilePageState extends State<RiderEditProfilePage> {
  Map<String, dynamic> riderDetails = {};

  @override
  void initState() {
    super.initState();
    getRiderDetails();
  }

  Future<void> getRiderDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      var reqUrl = '${url}rider?riderId=${jwtDecodedToken["_id"]}';
      final response = await http.get(
        Uri.parse(reqUrl),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          riderDetails = data['rider'];
        });
      } else {
        print('Failed to load rider details');
      }
    } catch (error) {
      print('Error fetching rider details: $error');
    }
  }

void showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Making edits? Reach out to our Admin Hotline to make changes.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Contact Admin Hotline'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}


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
                MaterialPageRoute(
                    builder: (context) => const IDVerificationScreen()),
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
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: riderDetails['profilePicURL']!=null
                          ? NetworkImage(riderDetails['profilePicURL'])
                          : const AssetImage(cRiderPFP) as ImageProvider<Object>,
                      ),
                    ),
                  ),
                  //Camera PFP Icon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        showEditDialog(context);
                      },
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
                      riderDetails['name'] ?? "Loading...",
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.cGreyColor2),
                      onPressed: () {
                        showEditDialog(context);
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
                        riderDetails['phoneNumber'] != null
                          ? riderDetails['phoneNumber'].toString()
                          : "Loading...",
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.cGreyColor2),
                      onPressed: () {
                        showEditDialog(context);
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
                      riderDetails['email'] ?? "Loading...",
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.cGreyColor2),
                      onPressed: () {
                        showEditDialog(context);
                      },
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
