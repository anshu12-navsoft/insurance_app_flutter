import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the text fields
  final TextEditingController emailController =
      TextEditingController(text: "test@example.com"); // default email
  final TextEditingController passwordController =
      TextEditingController(text: "password123"); // default password

  // Default credentials for testing
  static const defaultEmail = "test@example.com";
  static const defaultPassword = "password123";

  // Login logic
  void loginUser() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email & password")),
      );
      return;
    }

    if (email == defaultEmail && password == defaultPassword) {
      // Navigate to claims page
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Email input
            AuthTextField(
              hintText: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 16),

            // Password input
            AuthTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),
            const SizedBox(height: 24),

            // Login button
            AuthButton(
              text: "Login",
              onPressed: loginUser,
            ),
            const SizedBox(height: 16),

            // Signup navigation
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/signup");
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
