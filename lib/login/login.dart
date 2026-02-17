import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(Login());
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Economica'),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: AppColors.bg_color,
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SizedBox(height: 30,),

              // Logo
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
                  Image.asset('assets/icons/leaf.png', width: 80, height: 80),
                ],
              ),

              // Username and password inputs
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      style: TextStyle(
                        color: AppColors.font_color2,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "Username or Email",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(167, 0, 212, 145),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Color(0xFF064E3B),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(142, 0, 212, 145),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.font_color2,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      style: TextStyle(
                        color: AppColors.font_color2,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(167, 0, 212, 145),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Color(0xFF064E3B),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(142, 0, 212, 145),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.font_color2,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Forget Password
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.symmetric(horizontal: 35),
                width: double.infinity,
                height: 50,
                child: Text(
                  "Forget Password?",
                  style: TextStyle(
                    color: AppColors.font_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              
              // Login Button
              MaterialButton(
                onPressed: () {},
                minWidth: 300,
                height: 70,
                splashColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: AppColors.font_color,
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bg_color,
                  ),
                ),
              ),

              SizedBox(height: 30,),

              // Or
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
                      child: Image.asset("assets/icons/twitter.png", width: 50),
                    ),
                    // SizedBox(width: 20),
                    MaterialButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {},
                      child: Image.asset("assets/icons/google.png", width: 50),
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
                      child: Image.asset("assets/icons/apple.png", width: 50),
                    ),
                    
                  ],
                ),
              ),

              // Do not have an account ?
              Container(
                height: 50, alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Don't have an account?", style: TextStyle(fontSize: 20, color: AppColors.font_color2),),
                  SizedBox(width: 10,),
                  Text("Sign up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.font_color),),
                ],
              ),
              )
            
            ],
          ),
        ),
      ),
    );
  }
}
