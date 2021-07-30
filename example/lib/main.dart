import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';

void main() {
  runApp(ProgressButtonApp());
}

class ProgressButtonApp extends StatelessWidget {
  const ProgressButtonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Progress Button App",
      debugShowCheckedModeBanner: false,
      home: Material(
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProgressButton(
          value: 90.0,
          height: 65.0,
          onPressed: (progress) {},
          margin: const EdgeInsets.all(10.0),
          child: Text(
            "Uploading...",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
