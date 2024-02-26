import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/sizes.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';
import 'package:washcube_rider_app/src/features/screens/password%20reset/email_input_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/textfield_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool isNotValidateEmail = false;
  bool isNotValidatePassword = false;
  String errorTextEmail = '';
  String errorTextPassword = '';

  //Email Validation Function
  void emailvalidation() async {
    RegExp pattern = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (emailController.text.isNotEmpty) {
      if (pattern.hasMatch(emailController.text)) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OTPVerifyPage()),
        // );
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

  //Password Validation Function
  void passwordvalidation() async {
    // RegExp pattern = RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (passwordController.text.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => MapsPage()), 
        (route) => false
      );
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
      // TODO: Put Action Here After Password is Valid
    } else {
      setState(() {
        errorTextPassword = 'Please Enter Your Password.';
        isNotValidatePassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Email Text Form
            Theme(
              //Implementing Text Form Field Styling
              data: Theme.of(context).copyWith(
                inputDecorationTheme:
                    CTextFormFieldTheme.lightInputDecorationTheme,
              ),
              child: Form(
                child: TextField(
                  controller: emailController, //Validating Email Input
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  decoration: InputDecoration(
                    labelText: 'USERNAME / EMAIL',
                    hintText: 'yourname@example.com',
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, //Keeps Label Float Atop
                    errorText: isNotValidateEmail ? errorTextEmail : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: cDefaultSize,),
            //Password Text Form
            Theme(
              //Implementing Text Form Field Styling
              data: Theme.of(context).copyWith(
                inputDecorationTheme:
                    CTextFormFieldTheme.lightInputDecorationTheme,
              ),
              child: Form(
                child: TextField(
                  controller: passwordController, //Validating Password Input
                  obscureText: _isObscure, // Hide Password Input
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    hintText: 'password',
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
            const SizedBox(
              height: cDefaultSize,
            ),
            //Log In Button
            ElevatedButton(
              onPressed: () {
                emailvalidation();
                passwordvalidation();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, cButtonHeight),
                  maximumSize: const Size(1000, cButtonHeight)),
              child: Text(
                'Log In',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ),
            //Forgot Password Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmailInputScreen()),
                );
              },
              child: Text(
                'Forgot Password?',
                style: CTextTheme.greyTextTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
