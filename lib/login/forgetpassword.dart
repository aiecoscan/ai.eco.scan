import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';
import 'package:flutter/services.dart';

class ForgetPss extends StatefulWidget {
  const ForgetPss({super.key});

  @override
  State<ForgetPss> createState() => _ForgetPssState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ForgetPss());
}

class _ForgetPssState extends State<ForgetPss> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Economica'),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: AppColors.bg_color,
          padding: EdgeInsets.all(30),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 70,),

              // Forget Password Text
              Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reset Password", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),),
                  Text("Write Down Your or Phone Number and we will send you a link to reset your password", style: TextStyle(fontSize: 18, color: AppColors.font_color2, fontStyle: FontStyle.italic),),
                ],
              ) ,
              ),

              SizedBox(height: 50,),

              // Email or Phone Number
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
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
                        hintText: "Email / Phone Number",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(167, 0, 212, 145),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Color(0xFF064E3B),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
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
            
              SizedBox(height: 30,),
              
              // Reset Button
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
                  "Rquest Password Reset",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bg_color,
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
