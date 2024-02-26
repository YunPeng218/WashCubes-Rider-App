import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/common_widgets/barcode_scan_widget.dart';
import 'package:washcube_rider_app/src/common_widgets/help_widget.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/id_rider/id_verification_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import '../dropoff_lockersite/dropoff_lockersite1_screen.dart';

class PickupCentre extends StatefulWidget {
  const PickupCentre({super.key});

  @override
  State<PickupCentre> createState() =>
      _PickupCenterState();
}

class _PickupCenterState extends State<PickupCentre> {
  // Item List Data
  final List<Map<String, dynamic>> items = [
    {'action': 'order_number0000', 'scan': 'Scan', 'description': "Scan Tag", 'scanned': false,},
    {'action': 'order_number0001', 'scan': 'Scan', 'description': "Scan Tag", 'scanned': false,},
  ];

  // Handle barcode scan result
  void _handleScanResult(int index, String result) {
    setState(() {
      items[index]['scanned'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const SizedBox(width: 10.0,),
              //Rider ID QR Code Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IDVerificationScreen()),
                  );
                },
                child: const Icon(Icons.badge_outlined,color: AppColors.cBlackColor,)
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icons on the left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1 • Pick Up', style: CTextTheme.blueTextTheme.displaySmall,), //Job Step & Title
                      Text('Item Qty : 2', style: CTextTheme.greyTextTheme.displaySmall,), //
                    ],
                  ),
                ),
                //Destination Map Image
                Expanded(child: Image.asset(cMap01,height: size.height * 0.15)),
              ],
            ),
            const SizedBox(height: 10.0),

            //Help Button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const HelpWidget();
                  },
                );
              },
              child: Text('Help', style: CTextTheme.blackTextTheme.headlineMedium,)
            ),
            const SizedBox(height: 20.0),

            // Container 2
            ListTile(
              title: Text('Location', style: CTextTheme.greyTextTheme.headlineMedium,),
              subtitle: Text('Sunway Geo Doby Shop', style: CTextTheme.blackTextTheme.headlineMedium,),
            ),
            const Divider(),

            //Task List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // disable scrolling
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  //TODO: Anyway to Change Icon To Done
                  leading: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.cBlueColor2), //Left Icon
                  title: Text(item['action'], style: CTextTheme.blackTextTheme.headlineLarge,), //Action Title
                  //Scan Action Button
                  //Call for Barcode Scanner Widget
                  trailing: BarcodeScannerWidget(
                    isScanning: item['scanned'],
                    onScanResult: (result) => _handleScanResult(index, result),
                  ),
                  subtitle: Text(item['description'], style: CTextTheme.greyTextTheme.headlineSmall,),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                );

              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            //Picked Up Button
            Row(
              children: [
                Expanded(
                  //TODO: Add Disable Condition Until Scanning Is Done
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DropOffLocker()),
                        (route) => false
                      );
                    },
                    child: Text(
                      'Picked Up',
                      style: CTextTheme.blackTextTheme.headlineMedium,

                    )
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
