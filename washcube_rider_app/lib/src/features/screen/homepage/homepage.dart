import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/features/screen/laundrysite_screen/pickup_laundrysite_screen.dart';
import 'package:washcube_rider_app/src/features/screen/lockersite_screen/pickup_locker_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomePage',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: 
        Column(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickupLaundrySiteScreen()),
                );
              },
              child: Text('drop off @ laundrysite',),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickupLocker()),
                );
              },
              child: Text('pickup @ lockersite',),
            ),
          ],
        ),
        
        // TextButton(
        //   onPressed: scanBarcode,
        //   child: Text(
        //     scanResult == null ? 'Scan Barcode' : 'Scan result: $scanResult'),
        // ),
      ),
    );
  }
}