import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/job_details_page.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/month_bottom_modal.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Order List Data
  final List<Map<String, dynamic>> items = [
    {'orderID': 'Order ID : #9612', 'status': 'DONE', 'description': '23 Nov 2023, 22:13',},
    {'orderID': 'Order ID : #1023', 'status': 'CANCEL', 'description': '25 Nov 2023, 15:23',},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(cDefaultSize),
        child: Column(
          // shrinkWrap: true,
          children: [
            //TODO: Bottom Modal PopUp of Date Sorting & Change Month Displayed Based on Selected Month
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Month', style: CTextTheme.greyTextTheme.headlineMedium,),
                Text('November 2023', style: CTextTheme.blackTextTheme.headlineMedium,),
                IconButton(
                  onPressed: (){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return const MonthSelectModal();
                      },
                    );
                  }, 
                  icon: const Icon(Icons.access_time, color: AppColors.cBlueColor3,),),
              ],
            ),
            const Divider(),
            //Task List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // disable scrolling of the List Tile
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item['orderID'], style: CTextTheme.blackTextTheme.headlineLarge,), //List Title
                  trailing: Text(
                    //Check Order Status, if DONE > Blue, if CANCEL > Red
                    item['status'] == 'DONE' ? 'DONE' : 'CANCEL',
                    style: TextStyle(color: item['status'] == 'DONE' ? AppColors.cBlueColor3 : Colors.red,),
                  ),
                  subtitle: Text(item['description'], style: CTextTheme.greyTextTheme.headlineSmall,),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                  //Navigate to Detail Page of Selected Job Tile
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JobDetailsPage()),
                    );
                  },
                );
              },
            ),
            // ...List.generate(5, (index) => buildOrderListItem(index % 2 == 0)),
          ],
        ),
      ),
    );
  }

  // Widget buildOrderListItem(bool isDone) {
  //   return ListTile(
  //     title: Text('Order ID : #9612', style: CTextTheme.blackTextTheme.headlineMedium,),
  //     subtitle: Text('23 Nov 2023, 22:13 | +30 Points', style: CTextTheme.greyTextTheme.headlineSmall,),
  //     trailing: isDone
  //         ? const Chip(
  //       label: Text('DONE'),
  //       backgroundColor: Colors.green,
  //     )
  //         : const Chip(
  //       label: Text('CANCEL'),
  //       backgroundColor: Colors.red,
  //     ),
  //     onTap: (){
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const JobDetailsPage()),
  //       );
  //     },
  //   );
  // }
}
