import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_laundrysite/pickup_laundrysite_screen.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/locker_site_pickup_dropoff.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/select_pickup_locker_site.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/models/job.dart';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/models/order.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/laundry_site_pickup_dropoff.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/select_locker_site_orders.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';

class MapsPage extends StatefulWidget {
  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController; // Controller for Google map
  Location location = Location();
  late LatLng _currentLocation =
      LatLng(0.0, 0.0); // Initialize with default location
  bool statusLight = true; // Status Switch
  String? riderId;
  Job? activeJob;
  LockerSite? activeJobLocation;
  bool hasActiveJob = false;
  List<LockerSite> lockerSites = [];
  List<LockerCount> lockerCounts = [];
  Map<String, String> lockerCountMap = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getActiveJob();
    fetchLockerSites();
    fetchLockerOrderCount();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(userLocation.latitude!, userLocation.longitude!);
      });
      _moveToCurrentLocation();
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  void _moveToCurrentLocation() {
    mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  void getActiveJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (await prefs.getString('token')) ?? 'No token';
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    setState(() {
      riderId = jwtDecodedToken['_id'];
    });

    if (riderId != null && riderId != 'No token') {
      try {
        final response = await http.get(
          Uri.parse('${url}jobs?riderId=$riderId'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data.containsKey('job')) {
            final dynamic jobData = data['job'];
            setState(() {
              activeJob = Job.fromJson(jobData);
              hasActiveJob = true;
              print(activeJob?.jobType);
            });
          }

          if (data.containsKey('jobLocker')) {
            final dynamic lockerData = data['jobLocker'];
            setState(() {
              activeJobLocation = LockerSite.fromJson(lockerData);
            });
          }
        } else {
          print('Error: ${response.statusCode}');
          print('Error message: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  Future<void> fetchLockerSites() async {
    try {
      var reqUrl = url + 'lockers';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('lockers')) {
          final List<dynamic> lockerData = data['lockers'];
          final List<LockerSite> fetchedLockerSites =
              lockerData.map((site) => LockerSite.fromJson(site)).toList();
          setState(() {
            lockerSites = fetchedLockerSites;
          });
        } else {
          print('No lockers found.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load locker sites');
      }
    } catch (error) {
      print('Error fetching locker sites: $error');
    }
  }

  Future<void> fetchLockerOrderCount() async {
    try {
      var reqUrl = '${url}orders/ready-for-pickup/all-sites';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('mapArray')) {
          final List<dynamic> mapData = data['mapArray'];
          for (var item in mapData) {
            lockerCountMap[item[0] as String] =
                item[1].toString(); // Access key and value from each entry
          }
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load order count');
      }
    } catch (error) {
      print('Error fetching orders count: $error');
    }
  }

  void handleLockerSiteSelection(LockerSite selectedLockerSite) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PickupOrderSelect(selectedLockerSite: selectedLockerSite),
      ),
    );
  }

  void jobDetailsHandler() {
    print('YO');
    List<Order> orders = activeJob!.orders;
    for (Order order in orders) {
      OrderStage? orderStage = order.orderStage;
      String mostRecentStatus = orderStage!.getMostRecentStatus();
      print(mostRecentStatus);
      switch (mostRecentStatus) {
        case 'Drop Off':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LockerPickupDropoff(
                    activeJob: activeJob,
                    activeJobLocation: activeJobLocation,
                    jobType: 'Locker Pick Up')),
          );
          return;
        case 'Collected by Rider':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Site(activeJob, activeJobLocation, 'Site Drop Off')),
          );
          return;
        case 'Processing Complete':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Site(activeJob, activeJobLocation, 'Site Pick Up')),
          );
          return;
        case 'Out for Delivery':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LockerPickupDropoff(
                    activeJob: activeJob,
                    activeJobLocation: activeJobLocation,
                    jobType: 'Locker Drop Off')),
          );
          return;
      }
    }
  }

  void showActiveJobModal() {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Job Number: ${activeJob?.jobNumber ?? 'Loading...'}',
                        style: CTextTheme.blueTextTheme.headlineLarge,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: cDefaultSize,
                  ),
                  if (activeJob?.jobTypeString == 'Locker to Laundry Site') ...[
                    //First Step on Job
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activeJob?.pickedUpStatus == true
                            ? const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                backgroundImage: AssetImage(
                                    cDoubleCheckmark), // Replace with your image asset path
                                radius: 20, // Adjust the radius as needed
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                child: Text('1'),
                              ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PICK UP',
                                    style:
                                        CTextTheme.greyTextTheme.headlineMedium,
                                  ),
                                ],
                              ),
                              Text(
                                activeJobLocation?.name ?? 'Loading...',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                              Text(
                                activeJobLocation?.address ?? 'Loading...',
                                style: CTextTheme.greyTextTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                    //Second Step on the Job
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activeJob?.dropOffStatus == true
                            ? const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                backgroundImage: AssetImage(
                                    cDoubleCheckmark), // Replace with your image asset path
                                radius: 20, // Adjust the radius as needed
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                child: Text('2'),
                              ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'DROP OFF',
                                    style:
                                        CTextTheme.greyTextTheme.headlineMedium,
                                  ),
                                ],
                              ),
                              Text(
                                'i3 Laundry Centre',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                              Text(
                                'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
                                style: CTextTheme.greyTextTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                  ] else ...[
                    //First Step on Job
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activeJob?.pickedUpStatus == true
                            ? const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                backgroundImage: AssetImage(
                                    cDoubleCheckmark), // Replace with your image asset path
                                radius: 20, // Adjust the radius as needed
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                child: Text('1'),
                              ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PICK UP',
                                    style:
                                        CTextTheme.greyTextTheme.headlineMedium,
                                  ),
                                ],
                              ),
                              Text(
                                'i3 Laundry Centre',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                              Text(
                                'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
                                style: CTextTheme.greyTextTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                    //Second Step on the Job
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activeJob?.dropOffStatus == true
                            ? const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                backgroundImage: AssetImage(
                                    cDoubleCheckmark), // Replace with your image asset path
                                radius: 20, // Adjust the radius as needed
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColors.cGreyColor1,
                                child: Text('2'),
                              ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'DROP OFF',
                                    style:
                                        CTextTheme.greyTextTheme.headlineMedium,
                                  ),
                                ],
                              ),
                              Text(
                                activeJobLocation?.name ?? 'Loading...',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                              Text(
                                activeJobLocation?.address ?? 'Loading...',
                                style: CTextTheme.greyTextTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                  ],
                  //Accept Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: jobDetailsHandler,
                          child: Text(
                            'Continue Job',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
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
  }

  void showPickupLockerSiteModal() {
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
                  Text(
                    'Select Pickup Location',
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ),
                  // //First Step on Job
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const CircleAvatar(
                  //       backgroundColor: AppColors.cGreyColor1,
                  //       child: Text('1'),
                  //     ),
                  //     const SizedBox(
                  //       width: 10.0,
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 'PICK UP',
                  //                 style:
                  //                     CTextTheme.greyTextTheme.headlineMedium,
                  //               ),
                  //               Text(
                  //                 '3.4KM - 10 MIN',
                  //                 style:
                  //                     CTextTheme.blackTextTheme.headlineSmall,
                  //               ),
                  //             ],
                  //           ),
                  //           Text(
                  //             'Sunway Geo Residences',
                  //             style: CTextTheme.blackTextTheme.headlineMedium,
                  //           ),
                  //           Text(
                  //             'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
                  //             style: CTextTheme.greyTextTheme.labelLarge,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: cDefaultSize,
                  // ),

                  // //Second Step on the Job
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const CircleAvatar(
                  //       backgroundColor: AppColors.cGreyColor1,
                  //       child: Text('2'),
                  //     ),
                  //     const SizedBox(
                  //       width: 10.0,
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 'DROP OFF',
                  //                 style:
                  //                     CTextTheme.greyTextTheme.headlineMedium,
                  //               ),
                  //               Text(
                  //                 '2.8KM - 6 MIN',
                  //                 style:
                  //                     CTextTheme.blackTextTheme.headlineSmall,
                  //               ),
                  //             ],
                  //           ),
                  //           Text(
                  //             'i3 Laundry Centre',
                  //             style: CTextTheme.blackTextTheme.headlineMedium,
                  //           ),
                  //           Text(
                  //             'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
                  //             style: CTextTheme.greyTextTheme.labelLarge,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: cDefaultSize,
                  // ),
                  ListView.builder(
                    itemCount: lockerSites.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: LockerSiteOption(
                                title: lockerSites[index].name,
                                subtitle:
                                    lockerCountMap[lockerSites[index].id] ??
                                        'Loading...',
                                icon: Icons.location_on,
                                onTap: () {
                                  handleLockerSiteSelection(lockerSites[index]);
                                }),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showPickupLaundrySiteModal() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Google Map Navigation'),
      // ),
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
              mapType: MapType
                  .normal, // You can also change map type to satellite, hybrid, etc.
              markers: Set.of(
                [
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: _currentLocation,
                    infoWindow: InfoWindow(title: 'Your Location'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Menu Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.cWhiteColor),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: AppColors.cBlackColor,
                    ),
                  ),

                  //Status Switch
                  ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.cWhiteColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          statusLight
                              ? 'ONLINE'
                              : 'OFFLINE', //If Toggled: Online, Else: Offline
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
            hasActiveJob
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.cWhiteColor),
                          onPressed: showActiveJobModal,
                          child: const Text(
                            'View Active Job Details',
                          ),
                        ),
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.cWhiteColor),
                          onPressed: showPickupLockerSiteModal,
                          child: const Text(
                            'Pickup From Locker Site',
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.cWhiteColor),
                          onPressed: showPickupLaundrySiteModal,
                          child: const Text(
                            'Pickup From Laundry Site',
                          ),
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

class LockerSiteOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const LockerSiteOption(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.onTap,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: CTextTheme.blackTextTheme.headlineMedium,
          ),
          subtitle: Text(
            'Orders Ready For Pickup: $subtitle',
            style: CTextTheme.blackTextTheme.headlineSmall,
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
