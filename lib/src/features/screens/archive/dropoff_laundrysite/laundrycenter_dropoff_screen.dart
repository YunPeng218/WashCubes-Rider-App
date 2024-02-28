import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/common_widgets/help_widget.dart';
import 'package:washcube_rider_app/src/common_widgets/barcode_scan_widget.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/archive/id_rider/id_verification_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/textfield_theme.dart';

class DropOffLaundryCenterScreen extends StatefulWidget {
  const DropOffLaundryCenterScreen({super.key});

  @override
  State<DropOffLaundryCenterScreen> createState() =>
      _DropOffLaundryCenterScreenState();
}

class _DropOffLaundryCenterScreenState
    extends State<DropOffLaundryCenterScreen> {
  // Item List Data
  final List<Map<String, dynamic>> items = [
    {
      'number': '#1911109579612',
      'scan': 'Scan',
      'description': 'Scan to attached info',
      'scanned': false,
    },
    {
      'number': '#1911109579625',
      'scan': 'Scan',
      'description': 'Scan to attached info',
      'scanned': false,
    },
    {
      'number': '#1215020113224',
      'scan': 'Scan',
      'description': 'Scan to attached info',
      'scanned': false,
    },
  ];
  TextEditingController nameController = TextEditingController();
  bool isNotValidateName = false;
  String errorTextName = '';
  TextEditingController icController = TextEditingController();
  bool isNotValidateIC = false;
  String errorTextIC = '';

  // Handle barcode scan result
  void _handleScanResult(int index, String result) {
    setState(() {
      items[index]['scanned'] = true;
    });
  }

  //Name Validation Function
  void namevalidation() async {
    if (nameController.text.isNotEmpty) {
      // if (pattern.hasMatch(icController.text)) {
      //   // TODO: Put Action Here After Name is Valid
      // }
    } else {
      setState(() {
        errorTextName = "Please Enter Receiver's Name.";
        isNotValidateName = true;
      });
    }
  }

  //IC Validation Function
  void icvalidation() async {
    RegExp pattern = RegExp(r'^\d{6}-\d{2}-\d{4}$');
    if (icController.text.isNotEmpty) {
      if (pattern.hasMatch(icController.text)) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OrderCompleteScreen()),
        // );
        // TODO: Put Action Here After IC is Valid
      } else {
        setState(() {
          errorTextIC = 'Invalid IC Number Entered.';
          isNotValidateIC = true;
        });
      }
    } else {
      setState(() {
        errorTextIC = "Please Enter Receiver's IC Number.";
        isNotValidateIC = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          //Rider ID QR Code Button
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IDVerificationScreen()),
                );
              },
              child: const Icon(
                Icons.badge_outlined,
                color: AppColors.cBlackColor,
              )),
        ],
      ),
      //Scrollable Screen
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Order Detail Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #0000',
                        style: CTextTheme.greyTextTheme.headlineSmall,
                      ), //Order Number
                      Text(
                        '3 • Drop Off',
                        style: CTextTheme.blueTextTheme.displaySmall,
                      ), //Job Step & Title
                      Text(
                        'Laundry Centre',
                        style: CTextTheme.blackTextTheme.displaySmall,
                      ), //Destination Name
                    ],
                  ),
                ),
                //Destination Map Image
                Expanded(
                    child: Image.asset(cMap03, height: size.height * 0.15)),
              ],
            ),
            const SizedBox(height: 10.0),

            //Help Button
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const HelpWidget();
                    },
                  );
                },
                child: Text(
                  'Help',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                )),
            const SizedBox(height: 10.0),

            //Item Count Title
            Row(
              children: [
                Text(
                  'Item Qty',
                  style: CTextTheme.greyTextTheme.headlineSmall,
                ),
                const SizedBox(width: 20.0),
                Text(
                  '3 Item(s)',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Divider(),

            //Task List
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // disable scrolling
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: const Icon(Icons.qr_code_scanner_rounded,
                      color: Colors.blue), //Left Icon
                  title: Text(
                    item['number'],
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ), //Order Number
                  //Scan Action Button
                  //Call for Barcode Scanner Widget
                  trailing: BarcodeScannerWidget(
                    isScanning: item['scanned'],
                    onScanResult: (result) => _handleScanResult(index, result),
                  ),
                  subtitle: Text(
                    item['description'],
                    style: CTextTheme.greyTextTheme.headlineSmall,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  horizontalTitleGap: 10,
                );
              },
            ),
            const Divider(),
            const SizedBox(height: cDefaultSize),
            //Receiver Detail Input Section
            Text(
              'Receiver Details',
              style: CTextTheme.greyTextTheme.headlineSmall,
            ),
            const SizedBox(height: 20.0),
            //Receiver Name Input Field
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
                  controller: nameController, //Validating Name Input
                  decoration: InputDecoration(
                    hintText: 'Receiver Name',
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, //Keeps Label Float Atop
                    errorText: isNotValidateName ? errorTextName : null,
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
                  controller: icController, //Validating IC Input
                  decoration: InputDecoration(
                    hintText: '000000-00-0000',
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, //Keeps Label Float Atop
                    errorText: isNotValidateIC ? errorTextIC : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        namevalidation();
                        icvalidation();
                      },
                      child: Text(
                        'Drop Off',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
