import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;

class IDVerificationScreen extends StatefulWidget {
  const IDVerificationScreen({super.key});

    @override
  _IDVerificationScreenState createState() => _IDVerificationScreenState();
}

class _IDVerificationScreenState extends State<IDVerificationScreen> {
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


  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size; //Get Screen Size
    return Scaffold(
      //Top Bar of Back Button & Title
      appBar: AppBar(
        title: Text('ID Verification', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: Place Generated Rider QR Here
              Image.asset(cQRCode),
              const SizedBox(height: cDefaultSize,),
              //TODO: Place Rider PFP From Database to Here
              CircleAvatar(
                radius: cDefaultSize * 2,
                  backgroundImage: riderDetails['profilePicURL']!=null
                    ? NetworkImage(riderDetails['profilePicURL'])
                    : const AssetImage(cRiderPFP) as ImageProvider<Object>,
              ),
              Text( riderDetails['name'] ?? "Loading...", style: CTextTheme.blackTextTheme.displaySmall,),
            ],
          ),
        ),  
      ),
    );
  }
}