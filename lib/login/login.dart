import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';
import 'package:eco_scan/login/signup.dart';
import 'package:eco_scan/login/forgot_password_screen.dart';
import 'package:eco_scan/screens/user/home_screen.dart';
import 'package:eco_scan/screens/admin/admin_screen.dart';

// NEW: Import AuthService — this is the ONLY new import needed
import 'package:eco_scan/services/auth_service.dart';

// ============================================================
// LOGIN.DART — Fixed
// ============================================================
// BUG 2 FIX — isLoading getting stuck:
//   Root cause: _isLoading was set to true at the start of
//   _handleLogin(), and only reset to false inside the catch
//   blocks. On SUCCESSFUL login, the code navigated away without
//   ever resetting _isLoading = false.
//   When the user pressed Back and returned to Login, the button
//   was still in loading state (showing a spinner, not the text).
//
//   Fix: use a try/catch/FINALLY block. The finally block runs
//   whether the login succeeded OR failed, so _isLoading always
//   gets reset. This is the correct pattern for any async button.
// ============================================================

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // NEW: Loading state — shows spinner on button while login processes
  bool _isLoading = false;

  // NEW: Error message to show under inputs
  String? _errorMessage;

  // NEW: Extracted login logic into its own method
  // This keeps the build() method clean
  Future<void> _handleLogin() async {
    // Clear any previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      // Call AuthService.login() — this is the abstraction layer.
      // The screen doesn't know anything about Hive.
      // It just asks the service: "log this person in".
      final user = await AuthService.login(
        emailOrUsername: usernameController.text.trim(),
        password: passwordController.text,
      );

      // Navigate based on user role — same logic as before,
      // but now it uses the real user object from Hive
      if (!mounted) return;

      if (user.isAdmin) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AdminScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        Navigator.push(
          context,
          PageRouteBuilder(
            // NEW: Pass the user to HomeScreen so it can display their name/points
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen(user: user),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } on AuthException catch (e) {
      // AuthException has a user-friendly message we set in AuthService
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      // Catch-all for unexpected errors
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    } finally {
      // FIX: finally always runs — success, error, or exception.
      // This guarantees _isLoading is ALWAYS reset to false,
      // so the button never gets permanently stuck as a spinner.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.bgColor,
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),

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
                      color: AppColors.fontColor,
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
                    controller: usernameController,
                    style: TextStyle(
                      color: AppColors.fontColor2,
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
                          color: AppColors.fontColor2,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true, // NEW: added obscureText for security
                    style: TextStyle(
                      color: AppColors.fontColor2,
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
                          color: AppColors.fontColor2,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NEW: Error message display
            // Only visible when _errorMessage is not null
            if (_errorMessage != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),

            // Forget Password
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(horizontal: 35),
              width: double.infinity,
              height: 50,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    // MaterialPageRoute(builder: (context) => const ForgetPss()),
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  "Forget password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.fontColor,
                  ),
                ),
              ),
            ),

            // Login Button
            MaterialButton(
              // NEW: Disable button while loading
              onPressed: _isLoading ? null : _handleLogin,
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
                      "Log In",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.bgColor,
                      ),
                    ),
            ),

            SizedBox(height: 30),

            // Or
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
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
                            color: AppColors.fontColor2,
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
                        color: AppColors.fontColor,
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
                    child: Image.asset("assets/icons/facebook.png", width: 50),
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
              height: 50,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 20, color: AppColors.fontColor2),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: Text(
                      "Sign up",
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
}
