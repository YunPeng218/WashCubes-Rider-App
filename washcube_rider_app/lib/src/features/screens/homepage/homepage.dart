import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
    );
  }
}