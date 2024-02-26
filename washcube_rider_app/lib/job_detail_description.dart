import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Order ID : #9612'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Date\n23 Nov 2023, 22:13'),
                Text('Location\n2 Stops'),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('1 Sunway Geo Residences'),
            subtitle: Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor'),
          ),
          ListTile(
            title: Text('2 Taylor\'s University'),
            subtitle: Text('1, Jln Taylors, 47500 Subang Jaya, Selangor'),
          ),
          ListTile(
            title: Text('3 i3 Laundry Centre'),
            subtitle: Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor'),
          ),
        ],
      ),
    );
  }
}

class TaskPage extends StatefulWidget {
  final int page;

  TaskPage({Key? key, required this.page}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool isTaskDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page ${widget.page} / 4'),
      ),
      body: Column(
        children: [
          // Here we would build the task interface
          // For example, we could use a progress indicator for the task status
          LinearProgressIndicator(
            value: isTaskDone ? 1 : 0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          ElevatedButton(
            onPressed: () {
              // Placeholder for task completion logic
              setState(() {
                isTaskDone = !isTaskDone;
              });
            },
            child: Text(isTaskDone ? 'Reset Task' : 'Complete Task'),
          ),
        ],
      ),
    );
  }
}
