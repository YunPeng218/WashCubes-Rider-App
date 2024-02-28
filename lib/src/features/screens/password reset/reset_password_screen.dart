import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/password_updated_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/textfield_theme.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword(this.email, {super.key});

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
  void passwordValidation() {
    String newPassword = newpasswordController.text;
    String confirmPassword = confirmpasswordController.text;

    // Define validation criteria for new password
    RegExp uppercaseRegExp = RegExp(r'[A-Z]');
    RegExp lowercaseRegExp = RegExp(r'[a-z]');
    RegExp digitRegExp = RegExp(r'\d');
    RegExp specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (newPassword.isNotEmpty) {
      if (newPassword.length < 8) {
        setState(() {
          errorTextPassword = 'Password must be at least 8 characters long.';
          isNotValidatePassword = true;
        });
      } else if (!uppercaseRegExp.hasMatch(newPassword)) {
        setState(() {
          errorTextPassword = 'Password must contain at least one uppercase letter.';
          isNotValidatePassword = true;
        });
      } else if (!lowercaseRegExp.hasMatch(newPassword)) {
        setState(() {
          errorTextPassword = 'Password must contain at least one lowercase letter.';
          isNotValidatePassword = true;
        });
      } else if (!digitRegExp.hasMatch(newPassword)) {
        setState(() {
          errorTextPassword = 'Password must contain at least one digit.';
          isNotValidatePassword = true;
        });
      } else if (!specialCharRegExp.hasMatch(newPassword)) {
        setState(() {
          errorTextPassword = 'Password must contain at least one special character.';
          isNotValidatePassword = true;
        });
      } else {
        // New password is valid
        setState(() {
          errorTextPassword = '';
          isNotValidatePassword = false;
        });
      }
    } else {
      setState(() {
        errorTextPassword = 'Please Enter Your Password.';
        isNotValidatePassword = true;
      });
    }

    // Confirm password validation
    if (newPassword != confirmPassword) {
      setState(() {
        errorTextPassword1 = 'Passwords do not match.';
        isNotValidatePassword1 = true;
      });
    } else {
      // Passwords match
      setState(() {
        errorTextPassword1 = '';
        isNotValidatePassword1 = false;
      });
    }

    if (!isNotValidatePassword && !isNotValidatePassword1) {
      changePassword();
    }
  }

  // Confirm Password Validation Function
  void changePassword() async {
    var reqUrl = '${url}changePass';
    var response = await http.post(Uri.parse(reqUrl),
      body: {"email": widget.email, "newPassword": newpasswordController.text});
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 'Success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasswordUpdatedScreen()),
      );
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
                passwordValidation();
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