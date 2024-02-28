import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class IDVerificationScreen extends StatelessWidget {
  const IDVerificationScreen({super.key});

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
              CircleAvatar(radius: cDefaultSize * 2,child: Image.asset(cRiderPFP),),
              Text('Darren Lee', style: CTextTheme.blackTextTheme.displaySmall,),
            ],
          ),
        ),  
      ),
    );
  }
}