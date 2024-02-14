import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/reset_password_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class OTPVerifyScreen extends StatefulWidget {
  const OTPVerifyScreen({super.key});

  @override
  State<OTPVerifyScreen> createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
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
                // controller: phoneNumberController,
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
                  // otpValidation();
                  //TODO: Validate OTP Input
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
            //OTP Resend Link
            TextButton(
              onPressed: () {
                // resendOTP();
                //TODO: Resend OTP Action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResetPassword()),
                );
              }, // Resend OTP Code
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend Code',
                    style: TextStyle(
                        color: AppColors.cBlueColor2,
                        decoration: TextDecoration.underline),
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