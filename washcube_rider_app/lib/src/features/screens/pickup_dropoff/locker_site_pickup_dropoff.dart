// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import '../locker_qr/locker_qr_screen.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/models/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:washcube_rider_app/src/models/locker.dart';
import 'package:washcube_rider_app/src/models/job.dart';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:washcube_rider_app/src/features/screens/archive/dropoff_laundrysite/order_complete_screen.dart';

class LockerPickupDropoff extends StatefulWidget {
  Job? activeJob;
  LockerSite? activeJobLocation;
  final String jobType;
  LockerPickupDropoff(
      {super.key,
      required this.activeJob,
      required this.activeJobLocation,
      required this.jobType});

  @override
  State<LockerPickupDropoff> createState() => _LockerPickupDropoffState();
}

class _LockerPickupDropoffState extends State<LockerPickupDropoff> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  late List<String?> barcodeNum;
  late List<File?> imageFile;
  late List<String?> imageUrl;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    barcodeNum =
        List.generate(widget.activeJob!.orders.length, (index) => null);
    imageFile = List.generate(widget.activeJob!.orders.length, (index) => null);
    imageUrl = List.generate(widget.activeJob!.orders.length, (index) => null);
  }

  void comfirmation() async {
    try {
      var reqUrl = '${url}jobs/update-status';
      Map<String, dynamic> requestBody = {
        'jobNumber': widget.activeJob?.jobNumber,
      };
      if (widget.jobType == "Locker Pick Up") {
        requestBody['nextOrderStage'] = 'collectedByRider';
        requestBody['barcodeID'] = jsonEncode(barcodeNum);
      } else if (widget.jobType == 'Locker Drop Off') {
        requestBody['nextOrderStage'] = 'readyForCollection';
        requestBody['proofPicUrl'] = jsonEncode(imageUrl);
      }
      var response = await http.post(Uri.parse(reqUrl), body: requestBody);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                widget.jobType == "Locker Pick Up"
                    ? 'Pick Up Successful'
                    : 'Drop Off Successful',
                textAlign: TextAlign.center,
                style: CTextTheme.blackTextTheme.headlineLarge,
              ),
              content: Text(
                widget.jobType == "Locker Pick Up"
                    ? 'Please proceed sending the laundry to the laundry site.'
                    : 'Job Completed. Hooray!',
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
                                if (widget.jobType == "Locker Pick Up") {
                                  // await fetchUpdatedJob();
                                  // Navigator.pushAndRemoveUntil(context,
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) {
                                  //   return Site(
                                  //       widget.activeJob,
                                  //       widget.activeJobLocation,
                                  //       'Site Drop Off');
                                  // }), (r) {
                                  //   return false;
                                  // });
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const MapsPage();
                                  }), (r) {
                                    return false;
                                  });
                                } else if (widget.jobType ==
                                    "Locker Drop Off") {
                                  // Navigator.pushAndRemoveUntil(context,
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) {
                                  //   return const MapsPage();
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
                                }
                              }),
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
        throw Exception('Failed to pickup orders');
      }
    } catch (error) {
      print('Error picking up orders: $error');
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

  Future<void> launchCamera(ImageSource source, int index) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageFile[index] = File(pickedFile.path);
        uploadImage(index);
      }
    });
  }

  Future<void> uploadImage(int index) async {
    setState(() {
      isUploading = true;
    });
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/ddweldfmx/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'xcbbr3ok'
        ..files.add(
            await http.MultipartFile.fromPath('file', imageFile[index]!.path));
      final response = await request.send();
      print('Upload response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = utf8.decode(responseData);
        final jsonMap = jsonDecode(responseString);
        setState(() {
          final url = jsonMap['url'];
          imageUrl[index] = url;
        });
      }
    } catch (error) {
      print('Error uploading image: $error');
    } finally {
      setState(() {
        isUploading = false;
      });
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
    if (widget.jobType == "Locker Pick Up") {
      setState(() {
        barcodeNum[index] = barcodeScanRes;
      });
    } else if (widget.jobType == "Locker Drop Off") {
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
              title: Text('Barcode Error',
                  textAlign: TextAlign.center,
                  style: CTextTheme.blackTextTheme.headlineLarge),
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
                        child: Text('OK',
                            style: CTextTheme.blackTextTheme.headlineSmall),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              //Locker QR Code Button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LockerQRScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.kitchen,
                    color: AppColors.cBlackColor,
                  )),
              const SizedBox(
                width: 15.0,
              ),
              //Rider ID QR Code Button
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const IDVerificationScreen()),
              //       );
              //     },
              //     child: const Icon(
              //       Icons.badge_outlined,
              //       color: AppColors.cBlackColor,
              //     )),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activeJob?.jobTypeString ?? 'Loading...',
                    style: CTextTheme.blueTextTheme.displaySmall,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Job Number: ${widget.activeJob?.jobNumber ?? 'Loading...'}',
                    style: CTextTheme.greyTextTheme.headlineMedium,
                  ), //Order Number
                  //Job Step & Title
                  Text(
                    'Number of Orders: ${widget.activeJob?.orders.length ?? 'Loading...'}',
                    style: CTextTheme.greyTextTheme.headlineMedium,
                  ), //
                  Text(
                    widget.jobType == "Locker Pick Up"
                        ? 'Drop Off: WashCubes Laundry Site'
                        : 'Drop Off: ${widget.activeJobLocation?.name ?? 'Loading...'}',
                    style: CTextTheme.greyTextTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(),

            //Help Button
            // ElevatedButton(
            //     onPressed: () {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return const HelpWidget();
            //         },
            //       );
            //     },
            //     child: Text(
            //       'Help',
            //       style: CTextTheme.blackTextTheme.headlineMedium,
            //     )),
            // const SizedBox(height: 20.0),

            ListTile(
              title: Text(
                'Pick Up Location',
                style: CTextTheme.greyTextTheme.headlineMedium,
              ),
              subtitle: Text(
                '${widget.activeJobLocation?.name}',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ),
            ListTile(
              title: Text(
                'Address',
                style: CTextTheme.greyTextTheme.headlineMedium,
              ),
              subtitle: Text(
                '${widget.activeJobLocation?.address}',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(),
            SizedBox(
              height: 200.0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.activeJob?.orders.length ?? 0,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final Order order = widget.activeJob!.orders[index];
                  return Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Text(
                          'Order ${index + 1}/${widget.activeJob?.orders.length}',
                          style: CTextTheme.blackTextTheme.headlineMedium),
                      Text('Order Number: ${order.orderNumber}',
                          style: CTextTheme.blackTextTheme.headlineSmall),
                      if (widget.jobType == 'Locker Drop Off')
                        Text(
                            'Assigned Compartment: ${order.collectionSite?.compartmentNumber ?? 'Loading...'}',
                            style: CTextTheme.blueTextTheme.headlineSmall),
                      const SizedBox(height: 15.0),
                      ListTile(
                        leading: Image.asset(
                          barcodeNum[index] != null ? cDone : cTagDefault,
                          height: 50.0,
                          width: 50.0,
                        ),
                        title: Text(
                          widget.jobType == "Locker Pick Up"
                              ? barcodeNum[index] != null
                                  ? 'Barcode ID: ${barcodeNum[index]!}'
                                  : 'Barcode ID: None'
                              : 'Barcode ID: ${order.barcodeID}',
                          style: CTextTheme.blackTextTheme.labelLarge,
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => barcodeScanner(index),
                          child: Text(
                            'Scan Tag',
                            style: CTextTheme.blackTextTheme.labelLarge,
                          ),
                        ),
                      ),
                      if (widget.jobType == "Locker Drop Off")
                        ListTile(
                            leading: Stack(
                              children: [
                                Image.asset(
                                  imageUrl[index] != null
                                      ? cDone
                                      : cImageDefault,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                if (isUploading)
                                  const Positioned.fill(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Proof of Delivery',
                                  style: CTextTheme.blackTextTheme.labelLarge,
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100.0,
                              height: 36.0,
                              child: ElevatedButton(
                                onPressed: () =>
                                    launchCamera(ImageSource.camera, index),
                                child: Text('Take Photo',
                                    textAlign: TextAlign.center,
                                    style:
                                        CTextTheme.blackTextTheme.labelLarge),
                              ),
                            )),
                    ],
                  );
                },
              ),
            ),
            // Page Indicator
            const SizedBox(height: 10.0),
            Center(
              child: DotsIndicator(
                dotsCount: widget.activeJob?.orders.length ?? 0,
                position: currentPage,
                decorator: DotsDecorator(
                  color: Colors.grey[300]!,
                  activeColor: Colors.blue,
                  size: const Size.square(8.0),
                  activeSize: const Size(20.0, 8.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(),
            const SizedBox(height: 20.0),
            //Picked Up Button
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.jobType == "Locker Pick Up"
                              ? 'Confirm Pick Up'
                              : 'Confirm Drop Off',
                        ),
                      ],
                    ),
                  ),
                  onChanged: (position) {
                    if (position == SlidableButtonPosition.end) {
                      if ((widget.jobType == "Locker Pick Up" &&
                              barcodeNum[_pageController.page!.toInt()] !=
                                  null) ||
                          (widget.jobType == "Locker Drop Off" &&
                              barcodeNum[_pageController.page!.toInt()] !=
                                  null &&
                              imageUrl[_pageController.page!.toInt()] !=
                                  null)) {
                        if (_pageController.page! <
                            (widget.activeJob?.orders.length ?? 1) - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          comfirmation();
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error',
                                  textAlign: TextAlign.center,
                                  style:
                                      CTextTheme.blackTextTheme.headlineLarge),
                              content: Text(
                                'Please scan the tag ${widget.jobType == "Locker Pick Up" ? '' : 'and take picture for proof of delivery'} before proceeding to ${widget.jobType == "Locker Pick Up" ? 'pick up' : 'drop off'} the next order.',
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
                                          style: CTextTheme
                                              .blackTextTheme.headlineSmall,
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
                  }),
            ]),
            // Row(
            //   children: [
            //     Expanded(
            //       //TODO: Add Disable Condition Until Scanning Is Done
            //       child: ElevatedButton(
            //           onPressed: () {
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         const DropOffLaundryCenterScreen()),
            //                 (route) => false);
            //           },
            //           child: Text(
            //             'Picked Up',
            //             style: CTextTheme.blackTextTheme.headlineMedium,
            //           )),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
