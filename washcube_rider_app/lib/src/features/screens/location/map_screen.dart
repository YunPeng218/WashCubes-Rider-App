// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Map<String, Marker> _markers = {};
//   late GoogleMapController _mapController;
//   final Location _location = Location();

//   @override
//   void initState() {
//     super.initState();
//     _location.onLocationChanged.listen((LocationData currentLocation) {
//       // Update map with current location
//       _mapController.animateCamera(
//         CameraUpdate.newLatLng(LatLng(currentLocation.latitude!, currentLocation.longitude!)),
//       );
//     });
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Google Map Navigation')),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(3.0738, 101.5183), // Set initial map center (Subang Jaya area)
//           zoom: 14.0,
//         ),
//         markers: Set<Marker>.of(_markers.values),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle button press (e.g., open a menu, perform an action)
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
