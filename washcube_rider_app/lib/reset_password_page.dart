import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordUpdated = false;

  void updatePassword() {
    if (newPasswordController.text == confirmPasswordController.text) {
      // Assume password is updated on the backend
      setState(() {
        isPasswordUpdated = true;
      });
    } else {
      // Handle the error case where passwords don't match
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isPasswordUpdated ? buildPasswordUpdatedScreen() : buildResetForm(),
    );
  }

  Widget buildResetForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter new password',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm new password',
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: updatePassword,
            child: Text('Confirm Password'),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordUpdatedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.check_circle_outline, size: 80, color: Colors.blue),
          SizedBox(height: 24),
          Text('Password updated!', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
