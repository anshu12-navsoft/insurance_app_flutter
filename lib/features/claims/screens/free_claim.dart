import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../auth/widgets/auth_button.dart';
import '../../auth/widgets/auth_textfield.dart';

class FreeClaimScreen extends StatefulWidget {
  const FreeClaimScreen({super.key});

  @override
  State<FreeClaimScreen> createState() => _FreeClaimScreenState();
}

class _FreeClaimScreenState extends State<FreeClaimScreen> {
  final TextEditingController claimTitleController = TextEditingController();
  final TextEditingController claimDescriptionController =
      TextEditingController();

  void submitClaim() {
    final title = claimTitleController.text.trim();
    final description = claimDescriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // TODO: Replace with API call to submit claim
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Claim submitted successfully")),
    );

    // Clear fields
    claimTitleController.clear();
    claimDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("File a Claim"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AuthTextField(
              hintText: "Claim Title",
              controller: claimTitleController,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              hintText: "Claim Description",
              controller: claimDescriptionController,
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            AuthButton(
              text: "Submit Claim",
              onPressed: submitClaim,
            ),
          ],
        ),
      ),
    );
  }
}
