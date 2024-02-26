import 'dart:async';

import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class OrderCompleteScreen extends StatefulWidget {
  const OrderCompleteScreen({super.key});

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer to auto navigate back to homepage after preset time
    Timer(const Duration(seconds: 3), () {
      // Use pushReplacement to replace the current screen with the homepage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MapsPage()),
        (route) => false,
      );
    });
  }

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
                //TODO: Change Order Number Dynamically Depending on the Order Database
                'Order #00000000 Completed!',
                style: CTextTheme.blackTextTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushAndRemoveUntil(
              //         context, 
              //         MaterialPageRoute(builder: (context) => const HomePage()), 
              //         (route) => false
              //       );
              //     },
              //     child: Text('Back To Home', style: CTextTheme.blackTextTheme.headlineMedium,)),
            ],
          ),
        ),
      ),
    );
  }
}