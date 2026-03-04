import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    newPasswordFocus.addListener(() {
      setState(() {});
    });

    confirmPasswordFocus.addListener(() {
      setState(() {});
    });
  }

  Future<void> handleResetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password changed successfully"),
        backgroundColor: Color(0xFF00B97B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
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
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF15FB00),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Change Your Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Write Down Your New Password for your Account",
                    style: TextStyle(color: Color(0xFF00D492), fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  // New Password
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF00D492).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: newPasswordFocus.hasFocus
                            ? const Color(0xFF9AE600)
                            : const Color(0xFF00D492),
                        width: 2,
                      ),
                    ),

                    child: TextFormField(
                      controller: newPasswordController,
                      focusNode: newPasswordFocus,
                      obscureText: hideNewPassword,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }

                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }

                        return null;
                      },

                      decoration: InputDecoration(
                        hintText: "New Password",
                        hintStyle: const TextStyle(color: Color(0xFF00D492)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            hideNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF00D492),
                          ),
                          onPressed: () {
                            setState(() {
                              hideNewPassword = !hideNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF00D492).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: confirmPasswordFocus.hasFocus
                            ? const Color(0xFF9AE600)
                            : const Color(0xFF00D492),
                        width: 2,
                      ),
                    ),

                    child: TextFormField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocus,
                      obscureText: hideConfirmPassword,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm password";
                        }

                        if (value != newPasswordController.text) {
                          return "Passwords do not match";
                        }

                        return null;
                      },

                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: const TextStyle(color: Color(0xFF00D492)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF00D492),
                          ),
                          onPressed: () {
                            setState(() {
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

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

                      onPressed: isLoading ? null : handleResetPassword,

                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Reset My Password",
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
      ),
    );
  }
}
