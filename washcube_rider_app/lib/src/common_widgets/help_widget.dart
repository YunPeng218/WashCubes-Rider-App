import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Alert Dialog PopUp of Customer Support
    return AlertDialog(
      content: SingleChildScrollView(
        //Keep size to necessary height
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //PopUp Title
                Text(
                  'Need Help?',
                  textAlign: TextAlign.center,
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                //Close Button
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the alert dialog
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    //TODO: Link to Admin Hotline
                    onPressed: () {},
                    child: Text(
                      'Contact Admin Hotline',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                  )),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}