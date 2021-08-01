import 'package:flutter/material.dart';
import 'package:progress_value_button/progress_value_button.dart';

void main() {
  runApp(ProgressValueButtonApp());
}

class ProgressValueButtonApp extends StatelessWidget {
  const ProgressValueButtonApp({Key? key}) : super(key: key);

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loaded = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 2000),
      () => setState(() => _loaded = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loaded
            ? ProgressValueButton(
                value: 100.0,
                animationDuration: Duration(milliseconds: 8000),
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
              )
            : Container(),
      ),
    );
  }
}
