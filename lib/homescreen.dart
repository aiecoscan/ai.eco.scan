import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';
import 'package:eco_scan/login/login.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Economica'),
      home: Scaffold(
        body: Container(
          color: AppColors.bg_color,
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
                              color: AppColors.font_color,
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
                  box(
                    150,
                    200,
                    AppColors.bg_color2,
                    "Clean your\nStreets",
                    "assets/icons/recycle.png",
                  ),
                  SizedBox(width: 30),
                  box(
                    150,
                    200,
                    AppColors.bg_color2,
                    "Earn Points\n&Money",
                    "assets/icons/reward-points.png",
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(
                    150,
                    200,
                    AppColors.bg_color2,
                    "Learn About\nRecycling",
                    "assets/icons/book.png",
                  ),
                  SizedBox(width: 30),
                  box(
                    150,
                    200,
                    AppColors.bg_color2,
                    "Help Others\nLive Cleanly",
                    "assets/icons/help.png",
                  ),
                ],
              ),

              SizedBox(height: 50),

              // 3rd : Swipe to learn more ->
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Login(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Text(
                  "Press to continue",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
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
        Container(
          width: w,
          height: (h / 2),
          child: Image.asset(url, width: 30, height: 30),
        ),
        SizedBox(height: 10),
        Container(
          width: w,
          height: (h / 3),
          alignment: Alignment.center,
          child: Text(
            t,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
