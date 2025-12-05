import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class PolicyDetailsScreen extends StatelessWidget {
  final Map<String, String> policy;

  const PolicyDetailsScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(policy["policyNumber"] ?? "Policy Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              policy["type"] ?? "",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status: ${policy["status"] ?? ""}",
                    style: const TextStyle(fontSize: 16)),
                Text("Premium: ${policy["premium"] ?? ""}",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Policy Number",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            Text(policy["policyNumber"] ?? ""),
            const SizedBox(height: 16),
            Text(
              "Coverage Details",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            const Text(
              "• Coverage: Full\n• Validity: 12 months\n• Beneficiary: John Doe",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // TODO: Add action like renewing policy
                },
                child: const Text(
                  "Renew Policy",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
