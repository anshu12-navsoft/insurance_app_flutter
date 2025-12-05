import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed unused variable 'size'

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Welcome section
            Text(
              'Welcome Back, John!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Here is a summary of your insurance activities.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // 👇 Stats cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3, // makes cards more proportional
              children: const [
                DashboardCard(
                  title: "Policies",
                  value: "5",
                  icon: Icons.description,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: "Claims",
                  value: "2",
                  icon: Icons.assignment,
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: "Premiums Paid",
                  value: "\$1,200",
                  icon: Icons.payment,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: "Pending",
                  value: "1",
                  icon: Icons.pending_actions,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 👇 Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(
                  icon: Icons.add_circle_outline,
                  label: "File Claim",
                  onTap: () => Navigator.pushNamed(context, "/freeclaim"),
                ),
                QuickActionButton(
                  icon: Icons.payment,
                  label: "Make Payment",
                  onTap: () {},
                ),
                QuickActionButton(
                  icon: Icons.receipt_long,
                  label: "View Policies",
                  onTap: () => Navigator.pushNamed(context, "/viewpolicies"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 👇 Recent activity
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ActivityTile(
                  title: "Claim #123 approved",
                  date: "Dec 01, 2025",
                ),
                ActivityTile(title: "Policy renewed", date: "Nov 28, 2025"),
                ActivityTile(title: "Payment received", date: "Nov 25, 2025"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------
// Dashboard Card Widget
// --------------------
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

// --------------------
// Quick Action Button Widget
// --------------------
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

// --------------------
// Recent Activity Tile
// --------------------
class ActivityTile extends StatelessWidget {
  final String title;
  final String date;

  const ActivityTile({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(title),
      subtitle: Text(date),
      leading: const Icon(Icons.notifications, color: Colors.blue),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
