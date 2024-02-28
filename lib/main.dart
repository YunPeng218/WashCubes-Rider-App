import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/src/features/screens/location/map_screen.dart';
import 'package:washcube_rider_app/src/features/screens/welcome/welcome_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CAppTheme.lightTheme,
      home: (token != null) ? const MapsPage() : const WelcomeScreen(),
    );
  }
}
