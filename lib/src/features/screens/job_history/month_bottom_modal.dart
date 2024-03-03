import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class MonthSelectModal extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;

  const MonthSelectModal({
    Key? key,
    required this.selectedMonth,
    required this.selectedYear,
  }) : super(key: key);

  @override
  State<MonthSelectModal> createState() => _MonthSelectModalState();
}

class _MonthSelectModalState extends State<MonthSelectModal> {
  final List<Map<String, dynamic>> items = [];
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    generateMonthsList();
  }

  void generateMonthsList() {
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;
    for (int year = currentYear; year >= 2022; year--) {
      int endMonth = (year == currentYear) ? currentMonth : 12;
      for (int month = endMonth; month >= 1; month--) {
        String monthYear = _getMonthName(month, year);
        bool isCurrentMonthYear = (year == widget.selectedYear) && (month == widget.selectedMonth);
        items.add({'month-year': monthYear, 'status': isCurrentMonthYear});
      }
    }
  }

  String _getMonthName(int month, int year) {
    String monthYear = DateFormat('MMMM yyyy').format(DateTime(year, month));
    if ((year == currentDate.year) && (month == currentDate.month)) {
      return ("$monthYear (This Month)");
    } else {
      return monthYear;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
      child: Scaffold(
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Month List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // disable scrolling
                    itemCount: items.length * 2 - 1, // Adjusted to account for dividers
                    itemBuilder: (context, index) {
                      // If the index is odd, display a divider
                      if (index.isOdd) {
                        return const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        );
                      }
                      // If the index is even, display the ListTile
                      final itemIndex = index ~/ 2;
                      final item = items[itemIndex];
                      return ListTile(
                        title: Text(
                          item['month-year'],
                          style: item['status']
                              ? CTextTheme.blueTextTheme.headlineSmall
                              : CTextTheme.blackTextTheme.headlineSmall,
                        ), // List Title
                        trailing: Icon(
                          // Check Selected Status, If Selected > Blue Checkmark
                          item['status'] ? Icons.check : null,
                          color: item['status'] ? AppColors.cBlueColor3 : null,
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        horizontalTitleGap: 5,
                        selected: item['status'],
                        onTap: () {
                          String selectedMonthYear = item['month-year'];
                          Navigator.pop(context, selectedMonthYear);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}