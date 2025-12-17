import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insurance_app/features/dashboard/mobile_dashboard.dart';
import 'package:insurance_app/features/dashboard/web_dashboard.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // If opened in browser → ALWAYS show Web UI
    if (kIsWeb) {
      return const WebDashboard();
    }

    // If running as mobile app (Android/iOS)
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const MobileDashboard();
        } else {
          return const WebDashboard();
        }
      },
    );
  }
}
