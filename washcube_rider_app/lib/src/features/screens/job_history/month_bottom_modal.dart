import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class MonthSelectModal extends StatefulWidget {
  const MonthSelectModal({super.key});

  @override
  State<MonthSelectModal> createState() => _MonthSelectModalState();
}

class _MonthSelectModalState extends State<MonthSelectModal> {
  // Order List Data
  final List<Map<String, dynamic>> items = [
    {'month-year': 'September 2023', 'status': false,},
    {'month-year': 'October 2023', 'status': false,},
    {'month-year': 'November 2023', 'status': false,},
    {'month-year': 'December 2023', 'status': false,},
    {'month-year': 'January 2024', 'status': false,},
    {'month-year': 'February 2024', 'status': false,},
  ];
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //Month List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // disable scrolling
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['month-year'], style: item['status'] ? CTextTheme.blueTextTheme.headlineSmall : CTextTheme.blackTextTheme.headlineSmall,), //List Title
                    trailing: Icon(
                      //Check Selected Status, If Selected > Blue Checkmark
                      item['status'] ? Icons.check : null,
                      color: item['status'] ? AppColors.cBlueColor3 : null,
                    ),
                    contentPadding: const EdgeInsets.all(5),
                    horizontalTitleGap: 5,
                    selected: item['status'],
                    onTap: () {
                      setState(() {
                        item['status'] = !item['status']; // Toggle the status bool value
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: cDefaultSize,),
    
              //Accept Button
              //TODO: Send Selected Value to History Page & Change Month Displayed
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Select', style: CTextTheme.blackTextTheme.headlineMedium,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}