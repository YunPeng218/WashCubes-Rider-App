import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/dropoff_laundrysite/laundrycenter_dropoff_screen.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/pickup_locker_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

import '../pickup_laundrysite/pickup_laundrysite_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool statusLight = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Temp AppBar, remove Later
      appBar: AppBar(
        title: Text(
          'HomePage',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: 
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Menu Button
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(
                            AppColors.cWhiteColor),
                  ),
                  child: const Icon(
                    Icons.menu,
                  ),
                ),
                
                //Status Switch
                ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(
                            AppColors.cWhiteColor),
                  ),
                  child: Row(
                    children: [
                      Text(
                        statusLight ? 'ONLINE': 'OFFLINE', //If Toggled: Online, Else: Offline
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      const SizedBox(width: 5),
                      Switch(
                        value: statusLight, 
                        activeColor: Colors.green,
                        onChanged: (bool value) {
                          setState(() {
                            statusLight = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //TODO: Testing Purpose Pickup Laundry @ Locker Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickupLocker()),
                );
              },
              child: const Text('pickup @ lockersite',),
            ),

            //TODO: Testing Purpose Dropoff Laundry @ Laundrysite Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DropOffLaundryCenterScreen()),
                );
              },
              child: const Text('drop off @ laundrysite',),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickupCentre()),
                );
              },
              child: const Text('pickupfromcentre',),
            ),
            
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MapsPage()),
                );
              },
              child: const Text('maps',),
            ),
            //TODO: Test Purpose Accept Job Bottom Modal
            OutlinedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      // height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(cDefaultSize),
                        child: SingleChildScrollView(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Stop No. & Order Number
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                ////No Need for Multiple Steps as Pick Up of Different Location is Not Allowed as Discussed
                                // Column(
                                //   children: [
                                //     CircleAvatar(backgroundColor: AppColors.cButtonColor,child: Text('2'),),
                                //     Text('STOPS', style: CTextTheme.blackTextTheme.labelLarge,),
                                //   ],
                                // ),
                                Text('ORDER : #9612', style: CTextTheme.greyTextTheme.labelLarge,)
                              ],),
                              const SizedBox(height: cDefaultSize,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('PICK UP', style: CTextTheme.greyTextTheme.headlineMedium,),
                                  Text('3.4KM - 6 MIN', style: CTextTheme.blackTextTheme.headlineSmall,),
                                ],
                              ),
                              Text('Sunway Geo Residences', style: CTextTheme.blackTextTheme.headlineMedium,),
                              Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', style: CTextTheme.greyTextTheme.labelLarge,),
                              const SizedBox(height: cDefaultSize,),

                              //Accept Button
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Text('Accept', style: CTextTheme.blackTextTheme.headlineMedium,),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('accept selected job',),
            ),
          ],
        ),
      ),
    );
  }
}