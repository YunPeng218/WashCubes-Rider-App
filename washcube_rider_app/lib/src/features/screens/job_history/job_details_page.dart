import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/job_detail_dropoff.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/job_detail_pickup.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class JobDetailsPage extends StatelessWidget {
  JobDetailsPage({super.key});

  // Item List Data
  final List<Map<String, dynamic>> items = [
    {'location': 'Sunway Geo Residences', 'address': 'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', 'pageroute': const PickupJobDetailScreen(),},
    {'location': "Taylor's University", 'address': "1, Jln Taylors, 47500 Subang Jaya, Selangor", 'pageroute': const PickupJobDetailScreen(),},
    {'location': "i3 Laundry Centre", 'address': "Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor", 'pageroute': const DropoffJobDetailScreen(),},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: #9612',
              style: CTextTheme.blackTextTheme.displaySmall,
            ),
            const SizedBox(height: cDefaultSize),
            Row(
              children: [
                Text('Date', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: cDefaultSize,),
                Text(
                  '23 Nov 2023, 22:13',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Location', style: CTextTheme.greyTextTheme.headlineMedium,),
                const SizedBox(width: cDefaultSize,),
                Text(
                  '2 Stops',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(),
            const SizedBox(height: 10.0),
            Expanded(
              //Lists of Order Steps
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    //Step Number
                    leading: CircleAvatar(
                      backgroundColor: AppColors.cGreyColor1,
                      child: Text('${index + 1}', style: CTextTheme.blackTextTheme.headlineMedium,),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Location Title
                        Text(
                          item['location'],
                          style: CTextTheme.blackTextTheme.headlineLarge,
                        ),
                        //Location Address
                        Text(
                          item['address'],
                          style: CTextTheme.greyTextTheme.labelLarge,
                        ),
                      ],
                    ),
                    //Navigate to Detail of Order
                    subtitle: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item['pageroute']),
                        );
                      },
                      child: Text('See Details',style: CTextTheme.blueTextTheme.labelLarge,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
