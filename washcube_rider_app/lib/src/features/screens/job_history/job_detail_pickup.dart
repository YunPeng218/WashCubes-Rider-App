import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:washcube_rider_app/src/common_widgets/help_widget.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class PickupJobDetailScreen extends StatefulWidget {
  const PickupJobDetailScreen({super.key});

  @override
  State<PickupJobDetailScreen> createState() => _PickupJobDetailScreenState();
}

class _PickupJobDetailScreenState extends State<PickupJobDetailScreen> {
  // Item List Data
  final List<Map<String, dynamic>> items = [
    {'action': 'Apply Tag', 'description': 'Uploaded on 23 nov 2023, 22:03', 'scanned': false,},
    {'action': 'Scan Tag', 'description': "Item ID : 1911109579612", 'scanned': false,},
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
                      Text('Order #0000', style: CTextTheme.greyTextTheme.headlineSmall,), //Order Number
                      Text('1 • Pick Up', style: CTextTheme.blueTextTheme.displaySmall,), //Job Step & Title
                      Text('Item 1/2', style: CTextTheme.blackTextTheme.displaySmall,), //
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
            const SizedBox(height: 10.0),

            // User Order ID
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User Order ID', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: cDefaultSize,),
                Text('#906912', style: CTextTheme.blackTextTheme.headlineMedium,),
              ]
            ),
            const SizedBox(height: 10.0),

            // Location Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: cDefaultSize,),
                Expanded(
                  child: Text(
                    'Sunway Geo Residences', 
                    style: CTextTheme.blackTextTheme.headlineMedium,)),
              ]
            ),
            const SizedBox(height: 10.0),
            
            //Street Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Street', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: cDefaultSize,),
                Expanded(
                  child: Text(
                    'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', 
                    style: CTextTheme.blackTextTheme.headlineMedium,)),
              ]
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
                  leading: Image.asset(cDoubleCheckmark), //Left Icon
                  title: Text(item['action'], style: CTextTheme.blackTextTheme.headlineLarge,),
                  subtitle: Text(item['description'], style: CTextTheme.greyTextTheme.headlineSmall,),
                  trailing: Text('DONE', style: CTextTheme.blueTextTheme.headlineSmall,),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}