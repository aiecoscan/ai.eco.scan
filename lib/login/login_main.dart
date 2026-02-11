import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';

void main() {
  runApp(LoginMain());
}

class LoginMain extends StatelessWidget {
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
                height: 600,
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

                    // Login & SignUp Buttons
                    Container(
                      width: 300,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            minWidth: 300,
                            height: 100,
                            splashColor: Colors.lightGreenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: AppColors.font_color,
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.bg_color,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          MaterialButton(
                            onPressed: () {},
                            minWidth: 300,
                            height: 100,
                            splashColor: Colors.lightGreenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: AppColors.font_color,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.bg_color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Or Continue Using
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  color: const Color.fromARGB(105, 0, 212, 145),
                                  thickness: 0.5,
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "or",
                                  style: TextStyle(
                                    color: AppColors.font_color2,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Divider(
                                  color: const Color.fromARGB(105, 0, 212, 145),
                                  thickness: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Continue Using",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: AppColors.font_color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sign in Options
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {},
                            child: Image.asset(
                              "assets/icons/twitter.png",
                              width: 50,
                            ),
                          ),
                          // SizedBox(width: 20),
                          MaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {},
                            child: Image.asset(
                              "assets/icons/google.png",
                              width: 50,
                            ),
                          ),
                          // SizedBox(width: 20),
                          MaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {},
                            child: Image.asset(
                              "assets/icons/facebook.png",
                              width: 50,
                            ),
                          ),
                          // SizedBox(width: 20),
                          MaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {},
                            child: Image.asset(
                              "assets/icons/apple.png",
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
