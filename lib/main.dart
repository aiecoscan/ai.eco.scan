import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String bg_color = "0xff002c20";
    return MaterialApp(
      home: Scaffold(
        body:
          Container(
            color: Color(int.parse(bg_color)),
            width: 500,
            height: 1000,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text("EcoScan", style: TextStyle(color: Colors.white, fontSize: 30),),
                ],
              ),
            ),
          ),
      ),
    );
  }
}


