import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_dropoff/select_locker_site_orders.dart';

class LockerSiteDetailsPopup extends StatelessWidget {
  final LockerSite lockerSite;

  const LockerSiteDetailsPopup({
    super.key,
    required this.lockerSite,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        lockerSite.name,
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineLarge,
      ),
      content: Text(
        lockerSite.address,
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineMedium,
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[100]!)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockerPickupOrderSelect(
                          selectedLockerSite: lockerSite),
                    ),
                  );
                },
                child: Text(
                  'Pick Up',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
