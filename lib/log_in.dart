import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_parts_store/service/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Validate form before proceeding
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (context.mounted) {
        GoRouter.of(context).go('/home');
      }
    } catch (error) {
      _showErrorDialog(context, error.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(35.0),
          child: Form(
            key: _formKey, // ✅ Assigned form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 30, fontFamily: 'Kanit'),
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      'assets/images/icons/logo.png',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "Enter your credentials to continue!",
                  style: TextStyle(color: Colors.grey, fontFamily: 'Kanit'),
                ),
                SizedBox(height: 80),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your email"
                      : null,
                  decoration: _inputDecoration(
                      'E-mail Address', 'assets/images/icons/email.png'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your password"
                      : null,
                  decoration: _inputDecoration(
                      'Password', 'assets/images/icons/password.png'),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Kanit',
                          fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: _buttonStyle(Color(0xFFFFBF00), Colors.black),
                    onPressed: _isLoading
                        ? null
                        : () => _signInWithEmailAndPassword(context),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text('Log in'),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: _buttonStyle(Colors.black, Colors.white),
                    onPressed: () {}, // Google login (optional)
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.asset(
                        'assets/images/icons/google.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    label: Text('Log in using Google'),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don’t have an account? ',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Kanit'),
                          ),
                          TextSpan(
                            text: 'Sign up',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                );
                              },
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ],
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

  // Helper method for consistent input decoration
  InputDecoration _inputDecoration(String hintText, String iconPath) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(iconPath, width: 24, height: 24),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF9E9E9E)),
      ),
    );
  }

  // Helper method for consistent button styling
  ButtonStyle _buttonStyle(Color bgColor, Color fgColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      textStyle: TextStyle(fontFamily: 'Kanit', fontSize: 20),
      minimumSize: Size(double.infinity, 50),
    );
  }
}
