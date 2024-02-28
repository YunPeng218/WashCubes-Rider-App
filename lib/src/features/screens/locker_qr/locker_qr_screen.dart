import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class LockerQRScreen extends StatelessWidget {
  const LockerQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Locker QR',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/qr_code_id.png'),
              const SizedBox(height: 24),
              Text(
                'Show QR code to the locker for access.',
                style: CTextTheme.greyTextTheme.headlineSmall,
              ),
              const SizedBox(height: cDefaultSize),
              // Text('User Order ID : #906912', style: CTextTheme.blackTextTheme.headlineMedium,),
              // Text('Created by 23 Nov 2023, 14:29', style: CTextTheme.greyTextTheme.headlineSmall,),
            ],
          ),
        ),
      ),
    );
  }
}
