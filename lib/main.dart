import 'package:flutter/material.dart';
import 'package:flutter_clima_app/screens/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clima",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(

        primaryColor: Colors.blue,
        accentColor: Colors.white

      ),
      home: LoadingScreen(),
    );
  }
}
