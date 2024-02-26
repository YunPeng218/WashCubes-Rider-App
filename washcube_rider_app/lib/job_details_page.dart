import 'package:flutter/material.dart';
import 'package:washcube_rider_app/job_detail_description.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: #9612',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text('Date'),
            Text(
              '23 Nov 2023, 22:13',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text('Location'),
            Text(
              '2 Stops',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      index == 0 ? 'Sunway Geo Residences' : index == 1 ? 'Taylor\'s University' : 'i3 Laundry Centre',
                    ),
                    subtitle: Text(
                      'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const JobDetailDescriptionPage()),
                        );
                      },
                      child: Text('See Details'),
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
