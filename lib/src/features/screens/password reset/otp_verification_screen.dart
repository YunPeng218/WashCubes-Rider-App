import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/reset_password_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;

class OTPVerifyScreen extends StatefulWidget {
  final String email;
  String otp;
  bool isResendButtonEnabled = false;

  OTPVerifyScreen({required this.email, required this.otp, Key? key}): super(key: key);

  @override
  State<OTPVerifyScreen> createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  TextEditingController otpController = TextEditingController();
  late Timer timer;
  int remainingMinutes = 5;
  int remainingSeconds = 00;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else if (remainingMinutes > 0) {
          remainingMinutes--;
          remainingSeconds = 59;
        } else {
          widget.otp = '';
          widget.isResendButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void resendOTP() async {
    if (widget.isResendButtonEnabled) {
      var reqUrl = '${url}resetPassRequest';
      var response = await http.post(Uri.parse(reqUrl),
        body: {"email": widget.email});
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        widget.otp = jsonResponse['otp'];
        widget.isResendButtonEnabled = false;
        remainingMinutes = 5;
        remainingSeconds = 00;
      });
      timer.cancel();
      startTimer();
    }
  }

  void otpValidation() async {
    if (otpController.text == widget.otp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPassword(widget.email)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: CTextTheme.blackTextTheme.headlineLarge
            ),
            content: Text(
              'The OTP entered is incorrect. Please try again.',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            Text(
              'Enter the OTP sent to Email',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            const SizedBox(height: 30.0),
            //Pin Code Field
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
              child: PinCodeTextField(
                appContext: context,
                controller: otpController,
                length: 6,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                pastedTextStyle: Theme.of(context).textTheme.headlineMedium,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldWidth: 50,
                  inactiveColor: AppColors.cPrimaryColor,
                  selectedColor: AppColors.cPrimaryColor,
                  activeFillColor: AppColors.cWhiteColor,
                  selectedFillColor: AppColors.cWhiteColor,
                  inactiveFillColor: AppColors.cWhiteColor,
                ),
                onChanged: (value) {
                  setState(() {
                    // currentText = value;
                  });
                },
                onCompleted: (value) {
                  otpValidation();
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              "Didn't receive OTP code?",
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            Text(
              'Resend in ${remainingMinutes}m ${remainingSeconds}s',
              style: const TextStyle(
                color: AppColors.cGreyColor2,
              ),
            ),
            //OTP Resend Link
            TextButton(
              onPressed: () {
                resendOTP();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend Code',
                    style: TextStyle(
                      color: widget.isResendButtonEnabled
                          ? AppColors.cBlueColor2
                          : AppColors.cGreyColor2,
                      decoration: widget.isResendButtonEnabled
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: AppColors.cBlueColor2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}