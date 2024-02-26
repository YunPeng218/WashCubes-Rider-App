import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/password_updated_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/textfield_theme.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure1 = true;
  bool isNotValidatePassword = false;
  bool isNotValidatePassword1 = false;
  String errorTextPassword = '';
  String errorTextPassword1 = '';

  //Password Validation Function
  void passwordvalidation() async {
    // RegExp pattern = RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (newpasswordController.text.isNotEmpty) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomePage()),
      // );
      // if (pattern.hasMatch(passwordController.text)) {
      //   // Navigator.push(
      //   //   context,
      //   //   MaterialPageRoute(builder: (context) => const OTPVerifyPage()),
      //   // );
      //   // await http.post(Uri.parse(otpverification),
      //   //     body: {"phoneNumber": phoneNumberController.text});
      // } else {
      //   setState(() {
      //     errorTextPassword = 'Invalid Email Entered.';
      //     isNotValidate1 = true;
      //   });
      // }
      isNotValidatePassword = false;
      // TODO: Put Action Here After Password is Valid
    } else {
      setState(() {
        errorTextPassword = 'Please Enter Your Password.';
        isNotValidatePassword = true;
      });
    }
  }

  // Confirm Password Validation Function
  void confirmpasswordvalidation() async {
    if (confirmpasswordController.text.isNotEmpty) { //Check Whether Input is Empty
      if (confirmpasswordController.text == newpasswordController.text) { //Check Input Match Above Text Field
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PasswordUpdatedScreen()),
          (route) => false,
        );
        isNotValidatePassword1 = false;
      } else {
        setState(() {
          errorTextPassword1 = 'The Password Does Not Match';
          isNotValidatePassword1 = true;
        });
      }
      // TODO: Put Action Here After Password is Valid
    } else {
      setState(() {
        errorTextPassword1 = 'Please Enter Your Password.';
        isNotValidatePassword1 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Title & Default Back Button
      appBar: AppBar(
        title: Text('Reset Password', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize), //Around Screen Padding
        child: Column(
          children: [
            Text('Your new password must be different from previous used passwords',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            const SizedBox(height: cDefaultSize,),
            //New Password Text Form
            Theme(
              //Implementing Text Form Field Styling
              data: Theme.of(context).copyWith(
                inputDecorationTheme:
                    CTextFormFieldTheme.lightInputDecorationTheme,
              ),
              child: Form(
                child: TextField(
                  controller: newpasswordController, //Validating Password Input
                  obscureText: _isObscure, // Hide Password Input
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  decoration: InputDecoration(
                    labelText: 'NEW PASSWORD',
                    hintText: 'create new password',
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, //Keeps Label Float Atop
                    errorText: isNotValidatePassword ? errorTextPassword : null,
                    suffixIcon: GestureDetector(
                      onLongPressStart: (_) { //When User Hold the Icon
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      onLongPressEnd: (_) { //When User Let Go the Icon
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      child: Icon(
                        //If Obscure=true, use visibility_off icon, else use visibility icon 
                        _isObscure ? Icons.visibility_off : Icons.visibility, 
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: cDefaultSize,),
            //Confirm New Password Text Field
            Theme(
              //Implementing Text Form Field Styling
              data: Theme.of(context).copyWith(
                inputDecorationTheme:
                    CTextFormFieldTheme.lightInputDecorationTheme,
              ),
              child: Form(
                child: TextField(
                  controller: confirmpasswordController, //Validating Password Input
                  obscureText: _isObscure1, // Hide Password Input
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  decoration: InputDecoration(
                    labelText: 'CONFIRM PASSWORD',
                    hintText: 'confirm new password',
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, //Keeps Label Float Atop
                    errorText: isNotValidatePassword1 ? errorTextPassword1 : null,
                    suffixIcon: GestureDetector(
                      onLongPressStart: (_) { //When User Hold the Icon
                        setState(() {
                          _isObscure1 = !_isObscure1;
                        });
                      },
                      onLongPressEnd: (_) { //When User Let Go the Icon
                        setState(() {
                          _isObscure1 = !_isObscure1;
                        });
                      },
                      child: Icon(
                        //If Obscure=true, use visibility_off icon, else use visibility icon 
                        _isObscure1 ? Icons.visibility_off : Icons.visibility, 
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: cDefaultSize,),
            //Confirm Button
            ElevatedButton(
              onPressed: () {
                passwordvalidation();
                confirmpasswordvalidation();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, cButtonHeight),
                  maximumSize: const Size(1000, cButtonHeight)),
              child: Text(
                'Confirm Password',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}