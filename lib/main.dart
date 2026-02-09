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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Economica'),
      home: Scaffold(
        body: Container(
          color: Color(int.parse(bg_color)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              // 1st : the main text at the main screen
              Container(
                width: 500,
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text(
                            "EcoScan",
                            style: TextStyle(
                              color: Color(int.parse(font_color)),
                              fontSize: 70,
                              fontFamily: "Economica",
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/icons/leaf.png',
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                    SizedBox(height: 0),
                    Container(
                      width: 300,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        "Save Our Plant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // 2nd : The four squares at the main screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(150, 200, Color(int.parse(bg_color2)), "Clean your\nStreets", "assets/icons/recycle.png"),
                  SizedBox(width: 30),
                  box(150, 200, Color(int.parse(bg_color2)), "Earn Points\n&Money", "assets/icons/reward-points.png"),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(150, 200, Color(int.parse(bg_color2)), "Learn About\nRecycling", "assets/icons/book.png"),
                  SizedBox(width: 30),
                  box(150, 200, Color(int.parse(bg_color2)), "Help Others\nLive Cleanly", "assets/icons/help.png"),
                ],
              ),

              SizedBox(height: 50),

              // 3rd : Swipe to learn more ->
              Container(
                width: 310,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "Swipe to learn more ->",
                  style: TextStyle(
                    color: Color(int.parse(font_color)),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget box(double w, double h, Color c, String t, String url) {
  return Container(
    padding: EdgeInsets.all(10),
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(  
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: w , height: (h / 2),
        child:                         
        Image.asset(
          url,
          width: 30,
          height: 30,
            ),),
        SizedBox(height: 10,),
        Container(width: w, height: (h / 3), alignment: Alignment.center,
        child: Text(t, textAlign: TextAlign.center ,style: TextStyle(fontSize: 18, color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),),),
      ],
    ),
  );
}
