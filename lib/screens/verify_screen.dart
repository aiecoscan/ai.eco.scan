import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // Controllers لمربعات OTP
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // Timer
  int secondsLeft = 30;
  bool canResend = true;
  Timer? timer;

  // تشغيل العداد
  void startTimer() {
    setState(() {
      secondsLeft = 30;
      canResend = false;
    });

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        setState(() {
          canResend = true;
        });

        timer.cancel();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // التنقل بين مربعات OTP
  void handleInput(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Icon(Icons.arrow_back, color: Color(0xFF15FB00), size: 30),

              const SizedBox(height: 20),

              const Text(
                "Verify Your Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Please Enter 4-digit code sent to your email/phone number",
                style: TextStyle(color: Color(0xFF00D492), fontSize: 14),
              ),

              const SizedBox(height: 40),

              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: List.generate(
                  4,
                  (index) => Container(
                    width: 80,
                    height: 80,

                    decoration: BoxDecoration(
                      color: const Color(0xFF00D492).withOpacity(0.08),

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(
                        color: const Color(0xFF00D492),
                        width: 2,
                      ),
                    ),

                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],

                      maxLength: 1,

                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,

                      keyboardType: TextInputType.number,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),

                      onChanged: (value) {
                        handleInput(value, index);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE600),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Send Again
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive a code? ",

                    style: const TextStyle(
                      color: Color(0xFF00D492),
                      fontSize: 14,
                    ),

                    children: [
                      TextSpan(
                        text: canResend ? "Send Again" : "(${secondsLeft}s)",

                        style: TextStyle(
                          color: canResend
                              ? const Color(0xFF9AE600)
                              : Colors.grey,

                          fontWeight: FontWeight.bold,
                        ),

                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (!canResend) return;

                            startTimer();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("OTP sent again"),
                                backgroundColor: Color(0xFF00B97B),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                      ),
                    ],
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
