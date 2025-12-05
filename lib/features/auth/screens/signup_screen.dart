import 'package:flutter/material.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Account",
                  style: Theme.of(context).textTheme.headlineLarge),

              const SizedBox(height: 24),
              CustomTextField(hint: "Full Name", controller: nameCtrl),
              const SizedBox(height: 16),
              CustomTextField(hint: "Email", controller: emailCtrl),
              const SizedBox(height: 16),
              CustomTextField(
                hint: "Password",
                controller: passCtrl,
                obscure: true,
              ),

              const SizedBox(height: 24),
              CustomButton(text: "Sign Up", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
