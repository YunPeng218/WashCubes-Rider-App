import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/features/screens/pickup_lockersite/select_locker_site_orders.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';

class PickupLockerSiteSelect extends StatefulWidget {
  const PickupLockerSiteSelect({super.key});

  @override
  State<PickupLockerSiteSelect> createState() => _PickupLockerSiteSelectState();
}

class _PickupLockerSiteSelectState extends State<PickupLockerSiteSelect> {
  List<LockerSite> lockerSites = [];

  @override
  void initState() {
    super.initState();
    fetchLockerSites();
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

  void handleLockerSiteSelection(LockerSite selectedLockerSite) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PickupOrderSelect(selectedLockerSite: selectedLockerSite),
      ),
    );
  }

  void handleBackButtonPress() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MapsPage();
    }), (r) {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: handleBackButtonPress,
        ),
        title: Text(
          'Select Pickup Location',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Select Pickup Location'),
          ListView.builder(
            itemCount: lockerSites.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: LockerSiteOption(
                        title: lockerSites[index].name,
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
    );
  }
}

class LockerSiteOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const LockerSiteOption(
      {Key? key, required this.title, required this.onTap, required this.icon})
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
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
