import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:washcube_rider_app/job_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          //TODO: Bottom Modal PopUp of Date Sorting
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 3000,
                          title: '3,000',
                          color: Colors.blue,
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 7000,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 300,
                          title: '300',
                          color: Colors.blue,
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 1700,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(5, (index) => buildOrderListItem(index % 2 == 0)),
        ],
      ),
    );
  }

  Widget buildOrderListItem(bool isDone) {
    return ListTile(
      title: Text('Order ID : #9612'),
      subtitle: Text('23 Nov 2023, 22:13 | +30 Points'),
      trailing: isDone
          ? const Chip(
        label: Text('DONE'),
        backgroundColor: Colors.green,
      )
          : const Chip(
        label: Text('CANCEL'),
        backgroundColor: Colors.red,
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JobDetailsPage()),
        );
      },
    );
  }
}
