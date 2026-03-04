import 'package:flutter/material.dart';
import 'verify_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> handleReset() async {
    // تحقق من صحة الإيميل
    if (!formKey.currentState!.validate()) return;

    // تشغيل اللودينج
    setState(() {
      isLoading = true;
    });

    // محاكاة طلب سيرفر
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reset link sent to your email"),
        backgroundColor: Color(0xFF00B97B),
        duration: Duration(seconds: 2),
      ),
    );

    // الانتقال لصفحة التحقق
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerifyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF15FB00)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Forget Your Password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Write Down Your Email and we will send you a link to reset your password",
                  style: TextStyle(color: Color(0xFF00D492), fontSize: 14),
                ),

                const SizedBox(height: 40),

                // Email Input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  decoration: BoxDecoration(
                    color: const Color(0xFF00D492).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF00D492)),
                  ),

                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }

                      if (!value.contains("@")) {
                        return "Invalid email";
                      }

                      return null;
                    },

                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Color(0xFF00D492)),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // زر إرسال الطلب
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9AE600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    onPressed: isLoading ? null : handleReset,

                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            "Request Password Reset",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
