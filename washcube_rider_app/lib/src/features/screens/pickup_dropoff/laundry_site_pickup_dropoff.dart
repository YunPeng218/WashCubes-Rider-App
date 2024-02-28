// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/models/order.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/models/job.dart';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:http/http.dart' as http;
import 'package:slidable_button/slidable_button.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:washcube_rider_app/src/features/screens/archive/dropoff_laundrysite/order_complete_screen.dart';
//import 'package:washcube_rider_app/src/common_widgets/help_widget.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/textfield_theme.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';

class Site extends StatefulWidget {
  Job? activeJob;
  LockerSite? activeJobLocation;
  final String jobType;

  Site(this.activeJob, this.activeJobLocation, this.jobType, {Key? key})
      : super(key: key);

  @override
  State<Site> createState() => _SiteState();
}

class _SiteState extends State<Site> {
  late List<String?> barcodeNum;
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverICController = TextEditingController();
  bool allOrdersScanned = false;

  @override
  void initState() {
    super.initState();
    barcodeNum =
        List.generate(widget.activeJob!.orders.length, (index) => null);
  }

  bool isNameValid() {
    return receiverNameController.text.isNotEmpty;
  }

  bool isICValid() {
    RegExp pattern = RegExp(r'^\d{6}-\d{2}-\d{4}$');
    return (receiverICController.text.isNotEmpty &&
        pattern.hasMatch(receiverICController.text));
  }

  void confirmation() async {
    try {
      var reqUrl = '${url}jobs/update-status';
      Map<String, dynamic> requestBody = {
        'jobNumber': widget.activeJob?.jobNumber,
      };
      if (widget.jobType == "Site Drop Off") {
        requestBody['nextOrderStage'] = 'inProgress';
        requestBody['receiverName'] = receiverNameController.text;
        requestBody['receiverIC'] = receiverICController.text;
      } else if (widget.jobType == "Site Pick Up") {
        requestBody['nextOrderStage'] = 'outForDelivery';
      }
      var response = await http.post(Uri.parse(reqUrl), body: requestBody);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                widget.jobType == "Site Drop Off"
                    ? 'Drop Off Successful'
                    : 'Pick Up Successful',
                textAlign: TextAlign.center,
                style: CTextTheme.blackTextTheme.headlineLarge,
              ),
              content: Text(
                widget.jobType == "Site Drop Off"
                    ? 'Orders has been successfully dropped off at laundry site.'
                    : 'Please proceed sending the laundry to the assigned lockers.',
                textAlign: TextAlign.center,
                style: CTextTheme.blackTextTheme.headlineSmall,
              ),
              actions: <Widget>[
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
                            onPressed: () async {
                              if (widget.jobType == "Site Drop Off") {
                                // Navigator.pushAndRemoveUntil(context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) {
                                //   return MapsPage();
                                // }), (r) {
                                //   return false;
                                // });
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return OrderCompleteScreen(
                                    activeJob: widget.activeJob,
                                  );
                                }), (r) {
                                  return false;
                                });
                              } else {
                                //await fetchUpdatedJob();
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return const MapsPage();
                                }), (r) {
                                  return false;
                                });
                              }
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
        throw Exception('Failed to pickup/dropoff orders');
      }
    } catch (error) {
      print('Error picking up/dropping off orders: $error');
    }
  }

  Future<void> fetchUpdatedJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('token')) ?? 'No token';
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    var riderId = jwtDecodedToken['_id'];
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
              widget.activeJob = Job.fromJson(jobData);
            });
          }
          if (data.containsKey('jobLocker')) {
            final dynamic lockerData = data['jobLocker'];
            setState(() {
              widget.activeJobLocation = LockerSite.fromJson(lockerData);
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

  Future<void> barcodeScanner(int index) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = "Failed to scan";
    }
    if (!mounted) return;
    if (barcodeScanRes.isNotEmpty &&
        barcodeScanRes == widget.activeJob?.orders[index].barcodeID) {
      setState(() {
        barcodeNum[index] = barcodeScanRes;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Barcode Error',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            content: Text(
              'The scanned barcode ID does not match the expected barcode ID. Please try again.',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineSmall,
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Order Number
                    widget.jobType == 'Site Drop Off'
                        ? Text(
                            'DROP OFF',
                            style: CTextTheme.greyTextTheme.displaySmall,
                          )
                        : Text(
                            'PICK UP',
                            style: CTextTheme.greyTextTheme.displaySmall,
                          ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.activeJob?.jobTypeString ?? 'Loading...',
                      style: CTextTheme.blueTextTheme.displaySmall,
                    ), //Job Step & Title
                    const SizedBox(height: 10.0),
                    Text(
                      'Job Number: ${widget.activeJob?.jobNumber ?? 'Loading...'}',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                    Text(
                      'Number of Orders: ${widget.activeJob?.orders.length ?? 'Loading...'}',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                    Text(
                      widget.jobType == "Site Drop Off"
                          ? 'Drop Off: WashCubes Laundry Site'
                          : 'Drop Off: ${widget.activeJobLocation?.name ?? 'Loading...'}',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  shrinkWrap: true, // disable scrolling
                  itemCount: widget.activeJob?.orders.length,
                  itemBuilder: (context, index) {
                    final Order order = widget.activeJob!.orders[index];
                    return ListTile(
                      leading: Image.asset(
                        barcodeNum[index] != null ? cDone : cTagDefault,
                        height: 50.0,
                        width: 50.0,
                      ), //Left Icon
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Number: ${order.orderNumber}',
                            style: CTextTheme.blackTextTheme.labelLarge,
                          ),
                          Text(
                            'Barcode ID: ${order.barcodeID.isNotEmpty ? order.barcodeID : 'N/A'}',
                            style: CTextTheme.blackTextTheme.labelLarge,
                          ),
                        ],
                      ), //Order Number
                      trailing: SizedBox(
                        width: 100.0,
                        height: 36.0,
                        child: ElevatedButton(
                          onPressed: () => barcodeScanner(index),
                          child: Text('Scan Tag',
                              style: CTextTheme.blackTextTheme.labelLarge),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      horizontalTitleGap: 10,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              if (widget.jobType == "Site Drop Off")
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receiver Details',
                        style: CTextTheme.blackTextTheme.headlineLarge,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'RECEIVER',
                        style: CTextTheme.greyTextTheme.headlineSmall,
                      ),
                      const SizedBox(height: 5.0),
                      Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme:
                              CTextFormFieldTheme.lightInputDecorationTheme,
                        ),
                        child: Form(
                          child: TextField(
                            controller:
                                receiverNameController, //Validating Name Input
                            decoration: const InputDecoration(
                              hintText: 'Receiver Name',
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always, //Keeps Label Float Atop
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'I.C. NUMBER',
                        style: CTextTheme.greyTextTheme.headlineSmall,
                      ),
                      //IC Number Input Field
                      const SizedBox(height: 5.0),
                      Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme:
                              CTextFormFieldTheme.lightInputDecorationTheme,
                        ),
                        child: Form(
                          child: TextField(
                            controller:
                                receiverICController, //Validating IC Input
                            decoration: const InputDecoration(
                              hintText: '000000-00-0000',
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always, //Keeps Label Float Atop
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HorizontalSlidableButton(
                    isRestart: true,
                    width: MediaQuery.of(context).size.width / 1.3,
                    buttonWidth: 50.0,
                    color: const Color.fromARGB(255, 214, 214, 214),
                    buttonColor: Colors.blue[50],
                    dismissible: false,
                    label: const Center(
                      child: Icon(Icons.navigate_next_rounded),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.jobType == "Site Drop Off"
                                ? 'Confirm Drop Off'
                                : 'Confirm Pick Up',
                          ),
                        ],
                      ),
                    ),
                    onChanged: (position) {
                      if (position == SlidableButtonPosition.end) {
                        if (barcodeNum.any((barcode) => barcode == null)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Error',
                                  textAlign: TextAlign.center,
                                  style:
                                      CTextTheme.blackTextTheme.headlineLarge,
                                ),
                                content: Text(
                                  'Please scan all the barcode tags before proceeding.',
                                  textAlign: TextAlign.center,
                                  style:
                                      CTextTheme.blackTextTheme.headlineSmall,
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK',
                                              style: CTextTheme.blackTextTheme
                                                  .headlineSmall),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        if (widget.jobType == "Site Drop Off") {
                          if (isNameValid() == false) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Validation Error',
                                      textAlign: TextAlign.center,
                                      style: CTextTheme
                                          .blackTextTheme.headlineLarge),
                                  content: Text(
                                      'Please do not leave Receiver Name empty.',
                                      textAlign: TextAlign.center,
                                      style: CTextTheme
                                          .blackTextTheme.headlineSmall),
                                  actions: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK',
                                                style: CTextTheme
                                                    .blackTextTheme.labelLarge),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          } else if (isICValid() == false) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Validation Error',
                                      textAlign: TextAlign.center,
                                      style: CTextTheme
                                          .blackTextTheme.headlineLarge),
                                  content: Text(
                                      'Please enter a valid Receiver I.C. Number.',
                                      textAlign: TextAlign.center,
                                      style: CTextTheme
                                          .blackTextTheme.headlineSmall),
                                  actions: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK',
                                                style: CTextTheme
                                                    .blackTextTheme.labelLarge),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                        }
                        confirmation();
                      }
                    },
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     //Help Button
              //     ElevatedButton(
              //         onPressed: () {
              //           showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return const HelpWidget();
              //             },
              //           );
              //         },
              //         child: Text(
              //           'Help',
              //           style: CTextTheme.blackTextTheme.headlineMedium,
              //         )),
              //     const SizedBox(height: 10.0),
              //     //Item Count Title
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
