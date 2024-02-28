import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/common_widgets/barcode_scan_widget.dart';
import 'package:washcube_rider_app/src/common_widgets/help_widget.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/archive/dropoff_laundrysite/laundrycenter_dropoff_screen.dart';
import 'package:washcube_rider_app/src/features/screens/archive/id_rider/id_verification_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import '../locker_qr/locker_qr_screen.dart';

class PickupLocker extends StatefulWidget {
  const PickupLocker({super.key});

  @override
  State<PickupLocker> createState() => _PickupLockerState();
}

class _PickupLockerState extends State<PickupLocker> {
  // Item List Data
  final List<Map<String, dynamic>> items = [
    {
      'action': 'Apply Tag',
      'scan': 'Scan',
      'description': 'Apply tag & take photo',
      'scanned': false,
    },
    {
      'action': 'Scan Tag',
      'scan': 'Scan',
      'description': "Scan barcode's tag",
      'scanned': false,
    },
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
              //Locker QR Code Button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LockerQRScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.kitchen,
                    color: AppColors.cBlackColor,
                  )),
              const SizedBox(
                width: 10.0,
              ),
              //Rider ID QR Code Button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IDVerificationScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.badge_outlined,
                    color: AppColors.cBlackColor,
                  )),
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
                      Text(
                        'Order #0000',
                        style: CTextTheme.greyTextTheme.headlineSmall,
                      ), //Order Number
                      Text(
                        '1 • Pick Up',
                        style: CTextTheme.blueTextTheme.displaySmall,
                      ), //Job Step & Title
                      Text(
                        'Item 1/2',
                        style: CTextTheme.blackTextTheme.displaySmall,
                      ), //
                    ],
                  ),
                ),
                //Destination Map Image
                Expanded(
                    child: Image.asset(cMap01, height: size.height * 0.15)),
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
                child: Text(
                  'Help',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                )),
            const SizedBox(height: 20.0),

            // Location
            ListTile(
              title: Text(
                'Location',
                style: CTextTheme.greyTextTheme.headlineMedium,
              ),
              subtitle: Text(
                'Sunway Geo Residences',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ),
            ListTile(
              title: Text(
                'Street',
                style: CTextTheme.greyTextTheme.headlineMedium,
              ),
              subtitle: Text(
                'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ),
            const Divider(),

            //Task List
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // disable scrolling
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  //TODO: Anyway to Change Icon To Done
                  leading: const Icon(Icons.qr_code_scanner_rounded,
                      color: AppColors.cBlueColor2), //Left Icon
                  title: Text(
                    item['action'],
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ), //Action Title
                  //Scan Action Button
                  //Call for Barcode Scanner Widget
                  trailing: BarcodeScannerWidget(
                    isScanning: item['scanned'],
                    onScanResult: (result) => _handleScanResult(index, result),
                  ),
                  subtitle: Text(
                    item['description'],
                    style: CTextTheme.greyTextTheme.headlineSmall,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                );
              },
            ),
            const Divider(),
            const SizedBox(
              height: cDefaultSize,
            ),
            //Picked Up Button
            Row(
              children: [
                Expanded(
                  //TODO: Add Disable Condition Until Scanning Is Done
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DropOffLaundryCenterScreen()),
                            (route) => false);
                      },
                      child: Text(
                        'Picked Up',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
