import 'package:flutter/material.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpCtrl = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Verify OTP",
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 24),

              TextField(
                controller: otpCtrl,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Enter OTP",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),

              const SizedBox(height: 24),
              CustomButton(text: "Verify", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
