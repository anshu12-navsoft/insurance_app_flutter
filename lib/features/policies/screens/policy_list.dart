import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../screens/policy_details.dart'; // import the details screen

class ViewPoliciesScreen extends StatelessWidget {
  const ViewPoliciesScreen({super.key});

  final List<Map<String, String>> dummyPolicies = const [
    {
      "policyNumber": "POL123456",
      "type": "Health Insurance",
      "status": "Active",
      "premium": "\$200/month",
    },
    {
      "policyNumber": "POL654321",
      "type": "Car Insurance",
      "status": "Active",
      "premium": "\$150/month",
    },
    {
      "policyNumber": "POL987654",
      "type": "Life Insurance",
      "status": "Active",
      "premium": "\$100/month",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Your Policies"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyPolicies.length,
        itemBuilder: (context, index) {
          final policy = dummyPolicies[index];
          return GestureDetector(
            onTap: () {
              // Navigate to policy details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PolicyDetailsScreen(policy: policy),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy["policyNumber"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text("Type: ${policy["type"]}"),
                    Text("Status: ${policy["status"]}"),
                    Text("Premium: ${policy["premium"]}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
