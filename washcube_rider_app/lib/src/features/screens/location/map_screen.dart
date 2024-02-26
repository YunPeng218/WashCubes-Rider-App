import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController; // Controller for Google map
  Location location = Location();
  late LatLng _currentLocation = LatLng(0.0, 0.0); // Initialize with default location

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
      appBar: AppBar(
        title: Text('Google Map Navigation'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              // Set the initial position of the map.
              target: _currentLocation,
              zoom: 14.0,
            ),
            mapType: MapType.normal, // You can also change map type to satellite, hybrid, etc.
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
    );
  }
}
