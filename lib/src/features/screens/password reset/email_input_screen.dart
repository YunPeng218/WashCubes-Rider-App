import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/otp_verification_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/textfield_theme.dart';

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  TextEditingController emailController = TextEditingController();
  bool isNotValidateEmail = false;
  String errorTextEmail = '';

  //Email Validation Function
  void emailvalidation() async {
    RegExp pattern = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (emailController.text.isNotEmpty) {
      if (pattern.hasMatch(emailController.text)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OTPVerifyScreen()),
        );
        // await http.post(Uri.parse(otpverification),
        //     body: {"phoneNumber": phoneNumberController.text});
        // TODO: Put Action Here After Email is Valid
      } else {
        setState(() {
          errorTextEmail = 'Invalid Email Entered.';
          isNotValidateEmail = true;
        });
      }
    } else {
      setState(() {
        errorTextEmail = 'Please Enter Your Email.';
        isNotValidateEmail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          children: [
            Text('Kindly provide your email address, and we will send a verification OTP will sent to your email.',
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            const SizedBox(height: cDefaultSize,),
            //Email Address Text Field
            Theme(
              //Implementing Text Form Field Styling
              data: Theme.of(context).copyWith(
                inputDecorationTheme:
                    CTextFormFieldTheme.lightInputDecorationTheme,
              ),
              child: Form(
                child: TextField(
                  controller: emailController, //Validating Email Input
                  decoration: InputDecoration(
                    labelText: 'EMAIL ADDRESS',
                    hintText: 'yourname@example.com',
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, //Keeps Label Float Atop
                    errorText: isNotValidateEmail ? errorTextEmail : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: cDefaultSize,),
            //Send OTP Button
            ElevatedButton(
              onPressed: () {
                emailvalidation();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, cButtonHeight),
                  maximumSize: const Size(1000, cButtonHeight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, color: AppColors.cBlackColor),
                  const SizedBox(width: 8.0,),
                  Text(
                    'Send OTP',
                    style: CTextTheme.blackTextTheme.headlineMedium,
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