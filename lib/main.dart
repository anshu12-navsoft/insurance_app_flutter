import 'package:flutter/material.dart';
import 'package:insurance_app/features/claims/screens/free_claim.dart';
import 'package:insurance_app/features/policies/screens/add_policy.dart';
import 'package:insurance_app/features/policies/screens/policy_list.dart';
import '../../core/constants/colors.dart';
import './features/policies/screens/policy_details.dart';

// --------------------
// AUTH SCREENS
// --------------------
import '../../features/auth/screens/login_screen.dart';
import './features/profile/screens/profile.dart';
// --------------------
// CLAIMS SCREENS
// --------------------
import './features/claims//screens/claims_list.dart';
import './features/claims/screens/claim_chat.dart';

// --------------------
// DASHBOARD SCREEN
// --------------------
import './features/dashboard/dashboard.dart';
import './features/auth/screens/signup_screen.dart';

void main() {
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Insurance App",
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: "/login",

      // Use onGenerateRoute for screens that require arguments
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/login":
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case "/dashboard":
            return MaterialPageRoute(builder: (_) => const Dashboard());
          case "/freeclaim":
            return MaterialPageRoute(builder: (_) => const FreeClaimScreen());
          case "/viewpolicies":
            return MaterialPageRoute(
              builder: (_) => const ViewPoliciesScreen(),
            );
          case "/viewpoliciesdetails":
            final policy = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => PolicyDetailsScreen(policy: policy),
            );
          case "/claimlist":
            return MaterialPageRoute(builder: (_) => const ClaimListScreen());
          case "/signup":
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case "/freeclaim":
            return MaterialPageRoute(builder: (_) => const FreeClaimScreen());
          case "/addpolicy":
            return MaterialPageRoute(builder: (_) => const AddPolicyScreen());
          case "/profile":
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          default:
            return null;
        }
      },
    );
  }
}
