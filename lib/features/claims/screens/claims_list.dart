import 'package:flutter/material.dart';
import '../widgets/claim_card.dart';

class ClaimsListScreen extends StatelessWidget {
  const ClaimsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = [
      {"id": "CLM123", "title": "Car Accident Claim", "status": "In Review"},
      {"id": "CLM456", "title": "Health Insurance Claim", "status": "Approved"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Claims"),
        elevation: 1,
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: claims.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = claims[index];

          return ClaimCard(
  claimId: item["id"]!,
  title: item["title"]!,
  status: item["status"]!,
  subtitle: "Tap to view conversation",   // 👈 required if needed
  onTap: () {
    Navigator.pushNamed(context, "/claim_chat", arguments: item);
  },
);

        },
      ),
    );
  }
}
