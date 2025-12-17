import 'package:flutter/material.dart';
import 'package:insurance_app/features/claims/screens/free_claim.dart';
import 'package:insurance_app/features/policies/screens/add_policy.dart';

class WebSidebar extends StatefulWidget {
  const WebSidebar({super.key});

  @override
  State<WebSidebar> createState() => _WebSidebarState();
}

class _WebSidebarState extends State<WebSidebar>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _pulseController;

  final List<SidebarItem> menuItems = [
    SidebarItem(Icons.dashboard_rounded, 'Dashboard', 0),
    SidebarItem(Icons.policy_rounded, 'My Policies', 1),
    SidebarItem(Icons.description_rounded, 'Claims', 2),
    SidebarItem(Icons.payments_rounded, 'Payments', 3),
    SidebarItem(Icons.contact_support_rounded, 'Support', 4),
    SidebarItem(Icons.file_copy_rounded, 'Documents', 5),
    SidebarItem(Icons.settings_rounded, 'Settings', 6),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF0f1729)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...menuItems.map((item) => _buildNavItem(item)),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  _buildRenewalCard(),
                ],
              ),
            ),
          ),
          _buildUserProfile(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563eb), Color(0xFF1d4ed8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'SecureLife',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Insurance Portal',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(SidebarItem item) {
    final isActive = selectedIndex == item.index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFF2563eb), Color(0xFF1d4ed8)],
              )
            : null,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedIndex = item.index;
            });

            // --------------------------- NAVIGATION LOGIC ---------------------------
            switch (item.index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/dashboard');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/viewpolicies');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/claimlist');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/payments');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/support');
                break;
              case 5:
                Navigator.pushReplacementNamed(context, '/documents');
                break;
              case 6:
                Navigator.pushReplacementNamed(context, '/settings');
                break;
            }
            // ------------------------------------------------------------------------
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isActive ? Colors.white : Colors.white60,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildQuickActionButton(
            Icons.add_circle_outline_rounded,
            'New Claim',
            const Color(0xFFef4444),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FreeClaimScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildQuickActionButton(
            Icons.shopping_cart_outlined,
            'Buy Policy',
            const Color(0xFF10b981),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPolicyScreen()),
              );// Buy policy navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRenewalCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: Colors.amber.shade400),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Policy Renewal Due in 15 Days',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blueAccent,
            child: const Text('AS', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Smith',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('Policy #12345', style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String label;
  final int index;

  SidebarItem(this.icon, this.label, this.index);
}
