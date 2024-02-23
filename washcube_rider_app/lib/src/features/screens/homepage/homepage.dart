import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/features/screens/dropoff/laundrycenter_dropoff_screen.dart';
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
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DropOffLaundryCenterScreen()),
            );
          },
          child: Text('drop off',),
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
