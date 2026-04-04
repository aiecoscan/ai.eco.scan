import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';
import 'package:eco_scan/login/login.dart';
import 'package:eco_scan/screens/user/home_screen.dart';

// NEW: Import AuthService
import 'package:eco_scan/services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // NEW: Controllers for all fields — original had none!
  // Without controllers, you can't read what the user typed.
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // NEW: State variables
  bool _isLoading = false;
  String? _errorMessage;

  // NEW: Registration logic extracted into its own method
  Future<void> _handleSignUp() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // NEW: Basic client-side validation before calling service
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordController.text;
    final repeatPassword = _repeatPasswordController.text;

    // Check passwords match before sending to service
    if (password != repeatPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    try {
      // Call AuthService.register() — one call handles everything:
      // validation, hashing, saving to Hive, creating session
      final user = await AuthService.register(
        name: '$firstName $lastName', // Combine first + last name
        email: email,
        password: password,
        phone: phoneNumber, // Phone field not in your original signup form
      );

      if (!mounted) return;

      // Navigate to HomeScreen on success, passing the new user
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              HomeScreen(user: user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) =>
            false, // Clear the navigation stack — can't go back to signup
      );
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Registration failed. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.bgColor,
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),

            // Welcome Back text
            Container(
              height: 100,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "  Please fill your details below",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.fontColor2,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // User Data
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CHANGED: Added controller: _firstNameController
                  _buildTextField(_firstNameController, "First Name"),
                  SizedBox(height: 15),
                  // CHANGED: Added controller: _lastNameController
                  _buildTextField(_lastNameController, "Last Name"),
                  SizedBox(height: 15),
                  // CHANGED: Added controller: _emailController
                  _buildTextField(_emailController, "Email"),
                  SizedBox(height: 15),
                  // CHANGED: Added controller: _phoneNumberController
                  _buildTextField(_phoneNumberController, "Phone Number"),
                  SizedBox(height: 15),
                  // CHANGED: Added controller + obscureText for password
                  _buildTextField(
                    _passwordController,
                    "Password",
                    obscure: true,
                  ),
                  SizedBox(height: 15),
                  // CHANGED: Added controller + obscureText for confirm
                  _buildTextField(
                    _repeatPasswordController,
                    "Repeat Password",
                    obscure: true,
                  ),
                ],
              ),
            ),

            // NEW: Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),

            SizedBox(height: 30),

            // Sign up Button
            MaterialButton(
              onPressed: _isLoading ? null : _handleSignUp, // CHANGED
              minWidth: 300,
              height: 70,
              splashColor: Colors.lightGreenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: AppColors.fontColor,
              child: _isLoading
                  ? CircularProgressIndicator(color: AppColors.bgColor)
                  : Text(
                      "Sign-up",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.bgColor,
                      ),
                    ),
            ),

            SizedBox(height: 30),

            // Do not have an account ?
            Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 20, color: AppColors.fontColor2),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.fontColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Helper to build text fields consistently
  // This removes the massive duplication in the original signup.dart
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        color: AppColors.fontColor2,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color.fromARGB(167, 0, 212, 145),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Color(0xFF064E3B),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: const Color.fromARGB(142, 0, 212, 145),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.fontColor2, width: 1.5),
        ),
      ),
    );
  }
}
