import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ledgeroom/components/my_button.dart';
import 'package:ledgeroom/components/square_tile.dart';
import '../components/my_textfield.dart';
import '../services/google_sign_in_service.dart'; // Import the service
import 'forgot_password_page.dart';
import 'package:logger/logger.dart'; // Import logger

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignInService _googleSignInService = GoogleSignInService(); // Instantiate the service
  final Logger _logger = Logger(); // Instantiate the logger

  // Controllers for the username and password text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in user
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while loading
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Validate inputs
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      showErrorMessage('Fields cannot be empty');
      return;
    }

    // Try signing in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) Navigator.pop(context); // Close loading dialog
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      // Handle FirebaseAuthException errors
      if (e.code == 'user-not-found') {
        showErrorMessage('Incorrect Email');
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Incorrect Password');
      } else {
        _logger.e('FirebaseAuthException: $e');
        showErrorMessage('An unexpected error occurred');
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      _logger.e('Unexpected error: $e');
      showErrorMessage('An unexpected error occurred');
    }
  }

  // Sign in with Google
  void signInWithGoogle() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    User? user = await _googleSignInService.signInWithGoogle();
    if (mounted) Navigator.pop(context); // Close loading dialog

    if (user == null) {
      showErrorMessage('Google sign-in failed');
    } else {
      _logger.i('Signed in as ${user.displayName}');
      // Handle successful sign-in, navigate to the home screen, etc.
    }
  }

  // Show error message dialog
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),

              // Logo
              Image.asset('assets/images/logo.png', height: 150),

              const SizedBox(height: 40),

              // Welcome back text
              const Text(
                "Welcome back, you've been missed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // Username TextField
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // Password TextField
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Sign In Button
              MyButton(
                label: 'Sign In',
                onPressed: signUserIn,
              ),

              const SizedBox(height: 10),

              // Or continue with text
              const Text(
                'or continue with',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // Google Button
              SquareTile(
                onTap: () => GoogleSignInService().signInWithGoogle(),
                imagePath: 'assets/images/google_logo.png',
                ),


              const SizedBox(height: 25),

              // New user? Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New user?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
