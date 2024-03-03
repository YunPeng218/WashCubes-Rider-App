import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class JobDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;
  final Map<String, dynamic> jobLocker;

  JobDetailsPage({required this.job, required this.jobLocker, Key? key}) : super(key: key);

  String getFormattedDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    final timeZoneOffset = Duration(hours: 8);
    dateTime = dateTime.add(timeZoneOffset);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details', style: CTextTheme.blackTextTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Job Number: ${job['jobNumber']}",
              style: CTextTheme.blackTextTheme.displaySmall,
            ),
            const SizedBox(height: cDefaultSize),
            Row(
              children: [
                Text('Job Status', style: CTextTheme.greyTextTheme.headlineMedium),
                const SizedBox(width: cDefaultSize),
                Text(
                  job['isJobActive'] == true? 'In Process' : 'Completed',
                  style: job['isJobActive'] == true
                      ? CTextTheme.blueTextTheme.headlineMedium
                      : CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize),
            Row(
              children: [
                Text('Job Type', style: CTextTheme.greyTextTheme.headlineMedium),
                const SizedBox(width: cDefaultSize),
                Text(
                  "${job['jobType']}",
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize),
            Row(
              children: [
                Text('Number of Order', style: CTextTheme.greyTextTheme.headlineMedium),
                const SizedBox(width: cDefaultSize),
                Text(
                  "${job['orders'].length}",
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize),
            Row(
              children: [
                Text('Date', style: CTextTheme.greyTextTheme.headlineMedium),
                const SizedBox(width: cDefaultSize),
                Text(
                  getFormattedDateTime(job['createdAt']),
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              children: [
                Text('Locations Stopped', style: CTextTheme.greyTextTheme.headlineMedium),
                const SizedBox(width: cDefaultSize),
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.cGreyColor1,
                      child: Text('1', style: CTextTheme.blackTextTheme.headlineMedium),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['jobType'] == 'Locker To Laundry Site'
                              ? "${jobLocker['name']}"
                              : "I3 Laundry Centre",
                          style: CTextTheme.blackTextTheme.headlineLarge,
                        ),
                        Text(
                          job['jobType'] == 'Locker To Laundry Site'
                              ? "${jobLocker['address']}"
                              : "Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor",
                          style: CTextTheme.greyTextTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.cGreyColor1,
                      child: Text('2', style: CTextTheme.blackTextTheme.headlineMedium),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['jobType'] == 'Locker To Laundry Site'
                              ? "I3 Laundry Centre"
                              : "${jobLocker['name']}",
                          style: CTextTheme.blackTextTheme.headlineLarge,
                        ),
                        Text(
                          job['jobType'] == 'Locker To Laundry Site'
                              ? "Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor"
                              : "${jobLocker['address']}",
                          style: CTextTheme.greyTextTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}