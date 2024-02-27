import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/common_widgets/help_widget.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class DropoffJobDetailScreen extends StatefulWidget {
  const DropoffJobDetailScreen({super.key});

  @override
  State<DropoffJobDetailScreen> createState() =>
      _DropoffJobDetailScreenState();
}

class _DropoffJobDetailScreenState extends State<DropoffJobDetailScreen> {
  // Item List Data
  final List<Map<String, dynamic>> items = [
    {'number': '#1911109579612', 'description': 'Scan on 23 Nov 2023, 22:03', 'scanned': false,},
    {'number': '#1911109579625', 'description': 'Scan on 23 Nov 2023, 22:13', 'scanned': false,},
    {'number': '#1215020113224', 'description': 'Scan on 23 Nov 2023, 22:23', 'scanned': false,},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
      ),
      //Scrollable Screen
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Order Detail Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #0000', style: CTextTheme.greyTextTheme.headlineSmall,), //Order Number
                      Text('3 • Drop Off', style: CTextTheme.blueTextTheme.displaySmall,), //Job Step & Title
                      Text('Laundry Centre', style: CTextTheme.blackTextTheme.displaySmall,), //Destination Name
                    ],
                  ),
                ),
                //Destination Map Image
                Expanded(child: Image.asset(cMap03,height: size.height * 0.15)),
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

            //Item Count Title
            Row(
              children: [
                Text('Item Qty', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: 20.0),
                Text('${items.length} Item(s)', style: CTextTheme.blackTextTheme.headlineMedium,),
              ],
            ),
            const SizedBox(height: 20.0,),
            //Item Count Title
            Row(
              children: [
                Text('Receiver Name', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: 20.0),
                //TODO: Extract Name from Database
                Text('Thomas', style: CTextTheme.blackTextTheme.headlineMedium,),
              ],
            ),
            const SizedBox(height: 20.0,),
            //Item Count Title
            Row(
              children: [
                Text('Receiver I.C.', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: 20.0),
                //TODO: Extract I.C. from Database
                Text('780129-83-****', style: CTextTheme.blackTextTheme.headlineMedium,),
              ],
            ),
            const SizedBox(height: 20.0),
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
                  title: Text(item['number'], style: CTextTheme.blackTextTheme.headlineLarge,), //Order Number
                  trailing: Text('DONE', style: CTextTheme.blueTextTheme.headlineSmall,),
                  subtitle: Text(item['description'], style: CTextTheme.greyTextTheme.headlineSmall,),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
