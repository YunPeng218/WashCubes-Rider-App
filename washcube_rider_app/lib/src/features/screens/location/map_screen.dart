import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:washcube_rider_app/src/features/screens/left_nav_bar/profile_left_navigation_bar.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_dropoff/locker_site_pickup_dropoff.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/models/job.dart';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/models/order.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_dropoff/laundry_site_pickup_dropoff.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_dropoff/select_locker_site_orders.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_dropoff/select_laundry_site_orders.dart';
import 'package:washcube_rider_app/src/features/screens/location/locker_site_details.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController;
  Location location = Location();
  late LatLng _currentLocation = const LatLng(0.0, 0.0);
  late BitmapDescriptor userMarker;
  late BitmapDescriptor lockerMarker;
  late BitmapDescriptor laundrySiteMarker;
  bool isLocationLoading = true;

  List<double> laundrySiteCoordinates = [3.024181, 101.613449];
  String laundrySiteAddress =
      'No 10 Jalan TPP 1/10 Taman Industri Puchong 47100 Petaling Selangor Darul Ehsan';
  bool statusLight = true;

  String? riderId;
  Job? activeJob;
  LockerSite? activeJobLocation;
  bool hasActiveJob = false;
  List<LockerSite> lockerSites = [];
  Map<String, String> lockerPickupOrdersMap = {};
  Map<String, String> lockerDropoffOrdersMap = {};
  int totalLaundrySiteOrdersReadyToPickup = 0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    initCustomMarkers();
    _getCurrentLocation();
    getActiveJob();
    fetchLockerSites();
    fetchLockerPickupOrderCount();
    fetchLockerDropoffOrderCount();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(userLocation.latitude!, userLocation.longitude!);
        isLocationLoading = false;
      });
      _moveToCurrentLocation();
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  void _moveToCurrentLocation() {
    mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  void centerMapToMarker(MarkerId markerId) {
    Navigator.pop(context);
    Marker? tappedMarker = createMarkers().firstWhere(
      (marker) => marker.markerId == markerId,
    );

    if (mapController != null) {
      mapController!
          .animateCamera(CameraUpdate.newLatLng(tappedMarker.position));
    }
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

  Future<void> fetchLockerPickupOrderCount() async {
    try {
      var reqUrl = '${url}orders/ready-for-pickup/all-sites';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('mapArray')) {
          final List<dynamic> mapData = data['mapArray'];
          for (var item in mapData) {
            setState(() {
              lockerPickupOrdersMap[item[0] as String] = item[1].toString();
            });
          }
        }
      } else {
        throw Exception('Failed to load order count');
      }
    } catch (error) {
      print('Error fetching orders count: $error');
    }
  }

  Future<void> fetchLockerDropoffOrderCount() async {
    try {
      var reqUrl = '${url}orders/ready-for-dropoff/all-sites';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('mapArray')) {
          final List<dynamic> mapData = data['mapArray'];
          for (var item in mapData) {
            setState(() {
              lockerDropoffOrdersMap[item[0] as String] = item[1].toString();
              totalLaundrySiteOrdersReadyToPickup +=
                  int.parse(item[1].toString());
            });
          }
        }
      } else {
        throw Exception('Failed to load order count');
      }
    } catch (error) {
      print('Error fetching orders count: $error');
    }
  }

  void initCustomMarkers() async {
    userMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), cTrimiBig);
    lockerMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), cAppLogo);
    laundrySiteMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), cLaundrySiteIcon);
  }

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};
    lockerSites.forEach((lockerSite) {
      markers.add(
        Marker(
          markerId: MarkerId(lockerSite.id),
          position: LatLng(lockerSite.location.coordinates[1],
              lockerSite.location.coordinates[0]),
          icon: lockerMarker,
          infoWindow: InfoWindow(
              title: lockerSite.name,
              snippet:
                  'Orders Ready to Pick Up: ${lockerPickupOrdersMap[lockerSite.id]}',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LockerSiteDetailsPopup(
                      lockerSite: lockerSite,
                    );
                  },
                );
              }),
        ),
      );
    });
    markers.add(
      Marker(
        markerId: const MarkerId('laundry_site'),
        position: LatLng(laundrySiteCoordinates[0], laundrySiteCoordinates[1]),
        icon: lockerMarker,
        infoWindow: InfoWindow(
            title: 'i3Cubes Laundry Site',
            snippet:
                'Orders Ready to Pick Up: $totalLaundrySiteOrdersReadyToPickup',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'i3Cubes Laundry Site',
                      textAlign: TextAlign.center,
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    content: Text(
                      laundrySiteAddress,
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.red[100]!)),
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
                              onPressed: showPickupLaundrySiteModal,
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
                },
              );
            }),
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation,
        icon: userMarker,
        infoWindow: const InfoWindow(
          title: 'Your Location',
        ),
      ),
    );

    return markers;
  }

  void handleLockerSiteSelection(
      LockerSite selectedLockerSite, String jobType) async {
    switch (jobType) {
      case 'Locker to Laundry Site':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LockerPickupOrderSelect(selectedLockerSite: selectedLockerSite),
          ),
        );
        return;
      case 'Laundry Site to Locker':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaundrySitePickupOrderSelect(
                selectedLockerSite: selectedLockerSite),
          ),
        );
        return;
    }
  }

  void jobDetailsHandler() {
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
                builder: (context) => SitePickupDropoff(
                    activeJob, activeJobLocation, 'Site Drop Off')),
          );
          return;
        case 'Processing Complete':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SitePickupDropoff(
                    activeJob, activeJobLocation, 'Site Pick Up')),
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
                        textAlign: TextAlign.center,
                        style: CTextTheme.blueTextTheme.headlineLarge,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tap on location marker to navigate.',
                        style: CTextTheme.greyTextTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: cDefaultSize,
                  ),
                  if (activeJob?.jobTypeString == 'Locker to Laundry Site') ...[
                    //First Step on Job
                    GestureDetector(
                      onTap: () {
                        centerMapToMarker(MarkerId(
                            activeJobLocation?.id ?? 'current_location'));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          activeJob?.pickedUpStatus == true
                              ? const CircleAvatar(
                                  backgroundColor: AppColors.cGreyColor1,
                                  backgroundImage: AssetImage(cDoubleCheckmark),
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
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Text(
                                  activeJobLocation?.name ?? 'Loading...',
                                  style:
                                      CTextTheme.blackTextTheme.headlineMedium,
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
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                    //Second Step on the Job
                    GestureDetector(
                      onTap: () {
                        centerMapToMarker(const MarkerId('laundry_site'));
                      },
                      child: Row(
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
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Text(
                                  'i3 Laundry Centre',
                                  style:
                                      CTextTheme.blackTextTheme.headlineMedium,
                                ),
                                Text(
                                  laundrySiteAddress,
                                  style: CTextTheme.greyTextTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                  ] else ...[
                    //First Step on Job
                    GestureDetector(
                      onTap: () {
                        centerMapToMarker(const MarkerId('laundry_site'));
                      },
                      child: Row(
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
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Text(
                                  'i3 Laundry Centre',
                                  style:
                                      CTextTheme.blackTextTheme.headlineMedium,
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
                    ),
                    const SizedBox(
                      height: cDefaultSize,
                    ),
                    //Second Step on the Job
                    GestureDetector(
                      onTap: () {
                        centerMapToMarker(MarkerId(
                            activeJobLocation?.id ?? 'current_location'));
                      },
                      child: Row(
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
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Text(
                                  activeJobLocation?.name ?? 'Loading...',
                                  style:
                                      CTextTheme.blackTextTheme.headlineMedium,
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
                    textAlign: TextAlign.center,
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ),
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
                                    'Orders Ready For Pick Up: ${lockerPickupOrdersMap[lockerSites[index].id] ?? 'Loading...'}',
                                icon: Icons.location_on,
                                onTap: () {
                                  handleLockerSiteSelection(lockerSites[index],
                                      'Locker to Laundry Site');
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

  void showPickupLaundrySiteModal() {
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
                    'Select Drop Off Location',
                    textAlign: TextAlign.center,
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ),
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
                                    'Orders To Drop Off: ${lockerDropoffOrdersMap[lockerSites[index].id] ?? 'Loading...'}',
                                icon: Icons.location_on,
                                onTap: () {
                                  handleLockerSiteSelection(lockerSites[index],
                                      'Laundry Site to Locker');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          const LeftNavigationBar(), // Drawer widget for the left navigation bar
      body: SafeArea(
        child: Stack(
          children: [
            isLocationLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 14.0,
                    ),
                    mapType: MapType.normal,
                    markers: createMarkers(),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Menu Button
                  Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.cBlackColor,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.cWhiteColor),
                      ),
                    );
                  }),
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
                              backgroundColor:
                                  AppColors.cBarColor.withOpacity(0.85)),
                          onPressed: showActiveJobModal,
                          child: Text(
                            'View Active Job Details',
                            style: CTextTheme.whiteTextTheme.headlineMedium,
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
                              backgroundColor:
                                  AppColors.cBarColor.withOpacity(0.85)),
                          onPressed: showPickupLockerSiteModal,
                          child: Text(
                            'Pickup From Locker Site',
                            style: CTextTheme.whiteTextTheme.headlineMedium,
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  AppColors.cBarColor.withOpacity(0.85)),
                          onPressed: showPickupLaundrySiteModal,
                          child: Text(
                            'Pickup From Laundry Site',
                            style: CTextTheme.whiteTextTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
            //Current Location Button
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _moveToCurrentLocation();
                  },
                  tooltip: 'Get Current Location',
                  backgroundColor: AppColors.cBarColor.withOpacity(0.9),
                  foregroundColor: AppColors.cWhiteColor,
                  child: const Icon(Icons.my_location),
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              Text(
                subtitle,
                style: CTextTheme.blackTextTheme.headlineSmall,
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
