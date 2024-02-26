import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        title: Text('History'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Implement calendar picker
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
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
                Expanded(
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
          ? Chip(
        label: Text('DONE'),
        backgroundColor: Colors.green,
      )
          : Chip(
        label: Text('CANCEL'),
        backgroundColor: Colors.red,
      ),
    );
  }
}