// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';

class PickupLaundrySiteOrder extends StatefulWidget {
  final LockerSite? selectedLockerSite;

  const PickupLaundrySiteOrder({super.key, required this.selectedLockerSite});

  @override
  PickupLaundrySiteOrderState createState() => PickupLaundrySiteOrderState();
}

class PickupLaundrySiteOrderState extends State<PickupLaundrySiteOrder> {
  List<Order> ordersForPickup = [];
  List<String> selectedOrderIds = [];

  @override
  void initState() {
    super.initState();
    fetchPickupOrders();
  }

  Future<void> fetchPickupOrders() async {
    try {
      var reqUrl =
          '${url}orders/ready-for-pickup/laundry-site?lockerSiteId=${widget.selectedLockerSite?.id}';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('orders')) {
          final List<dynamic> orderData = data['orders'];
          final List<Order> orders =
              orderData.map((order) => Order.fromJson(order)).toList();
          setState(() {
            ordersForPickup = orders;
          });
        } else {
          print('No orders found.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  Future<void> submitPickupSelection() async {
    if (selectedOrderIds.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'No Orders Selected',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            actions: <Widget>[
              //Row & Expanded Widget For Button Centering
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            'OK',
                            style: CTextTheme.blackTextTheme.headlineSmall,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = (await prefs.getString('token')) ?? 'No token';
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
        String riderId = jwtDecodedToken['_id'];

        Map<String, dynamic> data = {
          'selectedOrderIds': selectedOrderIds,
          'jobType': 'Laundry Site To Locker',
          'lockerSiteId': widget.selectedLockerSite?.id,
          'riderId': riderId,
        };

        var reqUrl = '${url}orders/ready-for-pickup/laundry-site';
        final response = await http.post(Uri.parse(reqUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data.containsKey('newJobNumber')) {
            final jobNumber = data['newJobNumber'];

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Laundry Site to Locker Job Successfully Created',
                    textAlign: TextAlign.center,
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ),
                  content: Text(
                    'Your Job Number is $jobNumber',
                    textAlign: TextAlign.center,
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  ),
                  actions: <Widget>[
                    //Row & Expanded Widget For Button Centering
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Nice!',
                                  style:
                                      CTextTheme.blackTextTheme.headlineSmall,
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return MapsPage();
                                  }), (r) {
                                    return false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          } else {
            print('SERVER ERROR: Error confirming pickup orders');
          }
        } else {
          throw Exception('Failed to confirm pickup orders');
        }
      } catch (error) {
        print('Error confirming pickup orders: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomePage',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Select Orders to Pickup',
              style: CTextTheme.blueTextTheme.displaySmall),
          const SizedBox(
            height: 10.0,
          ),
          Text('You can select up to 3 orders to pick up.',
              style: CTextTheme.blackTextTheme.headlineMedium),
          const SizedBox(
            height: 10.0,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: ordersForPickup.length,
            itemBuilder: (context, index) {
              Order order = ordersForPickup[index];
              bool isSelected = selectedOrderIds.contains(order.id);
              return ListTile(
                title: Text(order.getFormattedDateTime(order.createdAt),
                    style: CTextTheme.greyTextTheme.labelLarge),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Text(
                      'Order No: ${order.orderNumber}',
                      style: CTextTheme.blackTextTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Status: ${order.orderStage?.getMostRecentStatus() ?? 'Loading...'}',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                  ],
                ),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        if (selectedOrderIds.length < 3) {
                          selectedOrderIds.add(order.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Maximum of 3 orders allowed!'),
                            ),
                          );
                        }
                      } else {
                        selectedOrderIds.remove(order.id);
                      }
                    });
                  },
                ),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue[100]!)),
            onPressed: submitPickupSelection,
            child: Text(
              'Proceed',
              style: CTextTheme.blackTextTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
