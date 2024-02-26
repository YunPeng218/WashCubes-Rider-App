import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';

class JobDetailDescriptionPage extends StatefulWidget {
  const JobDetailDescriptionPage({super.key});

  @override
  State<JobDetailDescriptionPage> createState() => _JobDetailDescriptionPageState();
}

class _JobDetailDescriptionPageState extends State<JobDetailDescriptionPage> {
  final List<Map<String, dynamic>> items = [
    {'action': 'Apply Tag', 'scan': 'Done', 'description': 'Apply tag & take photo', 'scanned': true,},
    {'action': 'Scan Tag', 'scan': 'Done', 'description': "Scan barcode's tag", 'scanned': true,},
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
        // actions: [
        //   Row(
        //     children: [
        //       //Locker QR Code Button
        //       ElevatedButton(
        //         onPressed: () {
        //           // Navigator.push(
        //           //   context,
        //           //   MaterialPageRoute(builder: (context) => const LockerQRScreen()),
        //           // );
        //         },
        //         child: const Icon(Icons.kitchen)
        //       ),
        //       const SizedBox(width: 10.0,),
        //       //Rider ID QR Code Button
        //       ElevatedButton(
        //         onPressed: () {
        //           // Navigator.push(
        //           //   context,
        //           //   MaterialPageRoute(builder: (context) => const IDVerificationScreen()),
        //           // );
        //         },
        //         child: const Icon(Icons.badge_outlined)
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0), //Padding Around Screen
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
                      Text('Order #0000'), //Order Number
                      Text('1 • Pick Up'), //Job Step & Title
                      Text('Item 1/2'), //
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
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return const HelpWidget();
                //   },
                // );
              },
              child: Text('Help')
            ),
            const SizedBox(height: 20.0),

            ListTile(
              title: Text('User Order ID'),
              subtitle: Text('#906912'),
            ),
            ListTile(
              title: Text('Location'),
              subtitle: Text('Sunway Geo Residences'),
            ),
            ListTile(
              title: Text('Street'),
              subtitle: Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor'),
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
                  leading: const Icon(Icons.qr_code_scanner_rounded), //Left Icon
                  title: Text(item['action']), //Action Title
                  //Scan Action Button
                  //Call for Barcode Scanner Widget
                  trailing: Text(item['scan']),
                  subtitle: Text(item['description']),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                );
              },
            ),
            // const Divider(),
            // const SizedBox(height: cDefaultSize,),
            //Picked Up Button
            // Row(
            //   children: [
            //     Expanded(
            //       //TODO: Add Disable Condition Until Scanning Is Done
            //       child: ElevatedButton(
            //         onPressed: (){
            //           Navigator.pushAndRemoveUntil(
            //             context, 
            //             MaterialPageRoute(builder: (context) => const DropOffLaundryCenterScreen()), 
            //             (route) => false
            //           );
            //         }, 
            //         child: Text(
            //           'Picked Up', 
            //           style: CTextTheme.blackTextTheme.headlineMedium,
            //         )
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}