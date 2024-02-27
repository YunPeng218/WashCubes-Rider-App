import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:washcube_rider_app/src/features/screens/left_nav_bar/profile_left_navigation_bar.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_laundrysite/pickup_laundrysite_screen.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/pickup_locker_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController; // Controller for Google map
  Location location = Location();
  late LatLng _currentLocation = LatLng(0.0, 0.0); // Initialize with default location
  bool statusLight = true; // Status Switch

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
      });
      _moveToCurrentLocation();
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  void _moveToCurrentLocation() {
    mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftNavigationBar(), // Drawer widget for the left navigation bar
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                // Set the initial position of the map.
                target: _currentLocation,
                zoom: 14.0,
              ),
              mapType: MapType.normal, // You can also change map type to satellite, hybrid, etc.
              markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: _currentLocation,
                    infoWindow: const InfoWindow(title: 'Your Location'),
                  ),
                },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Menu Button
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        }, 
                        icon: const Icon(Icons.menu, color: AppColors.cBlackColor,),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  AppColors.cWhiteColor),
                        ),
                      );
                    }
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
            ),
            //TODO: Test Purpose Accept Job from Locker Bottom Modal
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: AppColors.cWhiteColor),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(cDefaultSize),
                                child: SingleChildScrollView(
                                  child: Column(
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
                                      //First Step on Job
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(backgroundColor: AppColors.cGreyColor1,child: Text('1'),),
                                          const SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('PICK UP', style: CTextTheme.greyTextTheme.headlineMedium,),
                                                    Text('3.4KM - 10 MIN', style: CTextTheme.blackTextTheme.headlineSmall,),
                                                  ],
                                                ),
                                                Text('Sunway Geo Residences', style: CTextTheme.blackTextTheme.headlineMedium,),
                                                Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', style: CTextTheme.greyTextTheme.labelLarge,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: cDefaultSize,),
                            
                                      //Second Step on the Job
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(backgroundColor: AppColors.cGreyColor1,child: Text('2'),),
                                          const SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('DROP OFF', style: CTextTheme.greyTextTheme.headlineMedium,),
                                                    Text('2.8KM - 6 MIN', style: CTextTheme.blackTextTheme.headlineSmall,),
                                                  ],
                                                ),
                                                Text('i3 Laundry Centre', style: CTextTheme.blackTextTheme.headlineMedium,),
                                                Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', style: CTextTheme.greyTextTheme.labelLarge,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: cDefaultSize,),
                            
                                      //Accept Button
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              child: Text('Accept', style: CTextTheme.blackTextTheme.headlineMedium,),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const PickupLocker()),
                                                );
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
                          },
                        );
                      },
                      child: const Text('accept pickup job from locker',),
                    ),
                    //TODO: Test Purpose Accept Job from laundrySite Bottom Modal
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: AppColors.cWhiteColor),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(cDefaultSize),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      //Stop No. & Order Number
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                        Text('ORDER : #9612', style: CTextTheme.greyTextTheme.labelLarge,)
                                      ],),
                                      const SizedBox(height: cDefaultSize,),
                                      //First Step on Job
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(backgroundColor: AppColors.cGreyColor1,child: Text('1'),),
                                          const SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('PICK UP', style: CTextTheme.greyTextTheme.headlineMedium,),
                                                    Text('3.4KM - 10 MIN', style: CTextTheme.blackTextTheme.headlineSmall,),
                                                  ],
                                                ),
                                                Text('i3 Laundry Centre', style: CTextTheme.blackTextTheme.headlineMedium,),
                                                Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', style: CTextTheme.greyTextTheme.labelLarge,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: cDefaultSize,),
              
                                      //Second Step on the Job
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(backgroundColor: AppColors.cGreyColor1,child: Text('2'),),
                                          const SizedBox(width: 10.0,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('DROP OFF', style: CTextTheme.greyTextTheme.headlineMedium,),
                                                    Text('2.8KM - 6 MIN', style: CTextTheme.blackTextTheme.headlineSmall,),
                                                  ],
                                                ),
                                                Text('Sunway Geo Residences', style: CTextTheme.blackTextTheme.headlineMedium,),
                                                Text('Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor', style: CTextTheme.greyTextTheme.labelLarge,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: cDefaultSize,),
              
                                      //Accept Button
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              child: Text('Accept', style: CTextTheme.blackTextTheme.headlineMedium,),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const PickupCentre()),
                                                );},
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
                      child: const Text('accept pickup job from laundrysite',),
                    ),
                  ],
                ),
              ),
            //Current Location Button
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _moveToCurrentLocation();
                  },
                  tooltip: 'Get Current Location',
                  child: Icon(Icons.my_location),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
