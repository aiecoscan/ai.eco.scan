import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Colors
    const String bg_color = "0xff002c20";
    const String bg_color2 = "0xff003D2E";
    const String font_color = "0xff9AE600";

    return MaterialApp(
        theme: ThemeData(
    fontFamily: 'Economica',
  ),
      home: Scaffold(
        body: Container(
          color: Color(int.parse(bg_color)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // 1st : the main text at the main screen
              Container(width: 310, height: 250, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 300, height: 100, alignment: Alignment.center, 
                  child: Text("EcoScan", style: TextStyle(color: Color(int.parse(font_color)), fontSize: 70, fontFamily: "Economica", fontWeight: FontWeight.bold),),),
                  SizedBox(height: 0,),
                  Container(width: 300, height: 60, alignment: Alignment.center,
                  child: Text("Save Our Plant", style: TextStyle(color: Colors.white, fontSize: 50, fontStyle: FontStyle.italic),))
                ],
              ),
              ),

              SizedBox(height: 10),
              
              // 2nd : The four squares at the main screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(150, 180, Color(int.parse(bg_color2))),
                  SizedBox(width: 30),
                  box(150, 180, Color(int.parse(bg_color2))),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(150, 180, Color(int.parse(bg_color2))),
                  SizedBox(width: 30),
                  box(150, 180, Color(int.parse(bg_color2))),
                ],
              ),
              
              SizedBox(height: 50),
              
              // 3rd : Swipe to learn more ->
              Container(width: 310, height: 50, alignment: Alignment.center,
              child: Text("Swipe to learn more ->", style: TextStyle(color: Color(int.parse(font_color)), fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget box(double w, double h, Color c) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
