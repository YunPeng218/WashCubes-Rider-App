import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/job_details_page.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/month_bottom_modal.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> allJobLockerLocations = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchJobHistory();
  }

  Future<void> fetchJobHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      var reqUrl = '${url}jobsHistory?riderId=${jwtDecodedToken["_id"]}';
      final response = await http.get(
        Uri.parse(reqUrl),
      );
      if (response.statusCode == 200) {
        final List<dynamic>? jobsData = json.decode(response.body)['jobs'];
        if (jobsData != null) {
          List<Map<String, dynamic>> filteredJobs = jobsData.where((job) {
            DateTime jobDate = DateTime.parse(job['job']['createdAt']);
            return jobDate.month == selectedDate.month && jobDate.year == selectedDate.year;
          }).toList().cast<Map<String, dynamic>>();
          setState(() {
            items.clear();
            items.addAll(filteredJobs);
          });
        } else {
          throw Exception('No job data found');
        }
      } else {
        throw Exception('Failed to load job history');
      }
    } catch (e) {
      print('Error fetching job history: $e');
    }
  }

  void showMonthSelectModal(BuildContext context) async {
    String? selectedMonthYear = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MonthSelectModal(selectedMonth: selectedDate.month, selectedYear: selectedDate.year);
      },
    );
    if (selectedMonthYear != null) {
      List<String> parts = selectedMonthYear.split(' ');
      int selectedMonth = DateFormat('MMMM').parse(parts[0]).month;
      int selectedYear = int.parse(parts[1]);
      setState(() {
        selectedDate = DateTime(selectedYear, selectedMonth);
      });
      fetchJobHistory();
    }
  }

  String getFormattedDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    const timeZoneOffset = Duration(hours: 8);
    dateTime = dateTime.add(timeZoneOffset);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Month', style: CTextTheme.greyTextTheme.headlineMedium),
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () {
                    showMonthSelectModal(context);
                  },
                  icon: const Icon(Icons.access_time, color: AppColors.cBlueColor3),
                ),
              ],
            ),
            const Divider(),
            items.isEmpty
              ? Center(
                  child: Text('No job history found', style: CTextTheme.blackTextTheme.headlineMedium),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final job = item['job'];
                    final jobLocker = item['jobLocker'];
                    return ListTile(
                      title: Text("Job Number: ${job['jobNumber']}", style: CTextTheme.blackTextTheme.headlineLarge),
                      trailing: Text(
                        job['isJobActive'] == true ? 'In Process' : 'Completed',
                        style: job['isJobActive'] == true
                            ? CTextTheme.blueTextTheme.headlineSmall
                            : CTextTheme.blackTextTheme.headlineSmall,
                      ),
                      subtitle: Text(getFormattedDateTime(job['createdAt']), style: CTextTheme.greyTextTheme.headlineSmall),
                      contentPadding: const EdgeInsets.all(10),
                      horizontalTitleGap: 10,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JobDetailsPage(job: job, jobLocker: jobLocker)),
                        );
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}