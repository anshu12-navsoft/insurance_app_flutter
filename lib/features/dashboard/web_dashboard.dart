import 'package:flutter/material.dart';
import 'package:insurance_app/features/dashboard/widgets/web_dashboard_card.dart';
import 'dart:math' as math;
import '../dashboard/widgets/web_sidebar.dart';
import '../dashboard/web_dashboard.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  String selectedPeriod = 'This Month';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // breakpoint: >= 1000 -> show sidebar + content side-by-side
        // < 1000 -> show AppBar with hamburger that opens Drawer
        final showDrawer = width < 1000;

        return Scaffold(
          backgroundColor: const Color(0xFF0a0e27),
          drawer: showDrawer ? const WebSidebar() : null,

          appBar: showDrawer ? _buildAppBar() : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!showDrawer)
                  const SizedBox(width: 260, child: WebSidebar()),
                Expanded(
                  child: Column(
                    children: [
                      if (!showDrawer)
                        _buildTopBar(), // top bar only for wide layout
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Title for small screens (since topbar is hidden)
                              if (showDrawer) _buildCompactHeader(),

                              // Stats Row — use Wrap so cards move to next line on small widths
                              _buildResponsiveStats(),

                              const SizedBox(height: 24),

                              // Charts section — becomes column on small widths
                              LayoutBuilder(
                                builder: (context, chConstraints) {
                                  if (chConstraints.maxWidth < 900) {
                                    return Column(
                                      children: [
                                        _buildPremiumChart(),
                                        const SizedBox(height: 16),
                                        _buildPolicyBreakdown(),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _buildPremiumChart(),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: _buildPolicyBreakdown(),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 24),

                              // Dashboard Row — Activity + Active coverage; stack on small screens
                              LayoutBuilder(
                                builder: (context, drConstraints) {
                                  if (drConstraints.maxWidth < 900) {
                                    return Column(
                                      children: [
                                        _buildActivitySection(),
                                        const SizedBox(height: 16),
                                        _buildActiveCoverageSection(),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: _buildActivitySection(),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          flex: 4,
                                          child: _buildActiveCoverageSection(),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1a1f3a),
      elevation: 1,
      title: const Text('Insurance Dashboard'),
      actions: [
        _buildPeriodSelector(),
        const SizedBox(width: 12),
        _buildNotificationButton(),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTapDown: (d) => _showProfileMenu(d.globalPosition),
            child: const CircleAvatar(child: Icon(Icons.person)),
          ),
        ),
      ],
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Insurance Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Welcome back, Alex! Here's your overview",
                style: TextStyle(fontSize: 13, color: Colors.white60),
              ),
            ],
          ),
          const Spacer(),
          _buildPeriodSelector(),
          const SizedBox(width: 20),
          _buildNotificationButton(),
          const SizedBox(width: 20),
          _buildProfileButton(),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    // small-screen header shown when topbar is not visible
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: const [
          Text(
            "Insurance Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          // could show quick summary etc.
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: ['Today', 'This Week', 'This Month'].map((period) {
          final isSelected = selectedPeriod == period;
          return GestureDetector(
            onTap: () => setState(() => selectedPeriod = period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF2563eb), Color(0xFF1d4ed8)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white70,
                size: 22,
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFf59e0b),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFf59e0b,
                      ).withOpacity(_pulseController.value * 0.8),
                      blurRadius: 8,
                      spreadRadius: _pulseController.value * 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileButton() {
    return GestureDetector(
      onTapDown: (TapDownDetails details) =>
          _showProfileMenu(details.globalPosition),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Icon(
          Icons.person_rounded,
          color: Colors.white70,
          size: 20,
        ),
      ),
    );
  }

  void _showProfileMenu(Offset position) async {
    final selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      color: const Color(0xFF1a1f3a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: const [
              Icon(Icons.person, color: Colors.white70, size: 20),
              SizedBox(width: 10),
              Text("My Profile", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout_rounded, color: Colors.white70, size: 20),
              SizedBox(width: 10),
              Text("Logout", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );

    if (selected == 'profile') {
      Navigator.pushNamed(context, '/profile');
    }
    if (selected == 'logout') {
      // handle logout
    }
  }

  Widget _buildResponsiveStats() {
    // Use Wrap so the stat cards wrap on smaller widths
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      children: const [
        WebDashboardCard(title: 'Active Policies', subtitle: '12 Active'),
        WebDashboardCard(title: 'Total Coverage', subtitle: '\$850K Total'),
        WebDashboardCard(title: 'Pending Claims', subtitle: '2 In Review'),
        WebDashboardCard(title: 'Premium Paid', subtitle: '\$4,832 This Year'),
      ],
    );
  }

  Widget _buildPremiumChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Payments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Monthly payment history',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF10b981).withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  'Up to Date',
                  style: TextStyle(
                    color: Color(0xFF10b981),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: InsuranceChartPainter(),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Policy Types',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPolicyItem('Health Insurance', 4, const Color(0xFF2563eb)),
          const SizedBox(height: 10),
          _buildPolicyItem('Auto Insurance', 3, const Color(0xFF10b981)),
          const SizedBox(height: 10),
          _buildPolicyItem('Home Insurance', 2, const Color(0xFF8b5cf6)),
          const SizedBox(height: 10),
          _buildPolicyItem('Life Insurance', 3, const Color(0xFFf59e0b)),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String name, int count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count ${count == 1 ? 'Policy' : 'Policies'}',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: count / 12,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF2563eb),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            'Claim Approved',
            'Health Insurance - \$1,250',
            '2 hours ago',
            Icons.check_circle_rounded,
            const Color(0xFF10b981),
          ),
          const SizedBox(height: 10),
          _buildActivityItem(
            'Premium Payment',
            'Auto Insurance - \$425/mo',
            'Yesterday',
            Icons.payment_rounded,
            const Color(0xFF2563eb),
          ),
          const SizedBox(height: 10),
          _buildActivityItem(
            'Policy Renewed',
            'Home Insurance #HI-5678',
            '3 days ago',
            Icons.refresh_rounded,
            const Color(0xFF8b5cf6),
          ),
          const SizedBox(height: 10),
          _buildActivityItem(
            'Document Uploaded',
            'Medical records.pdf',
            '5 days ago',
            Icons.upload_file_rounded,
            const Color(0xFF06b6d4),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActiveCoverageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2563eb),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Coverage',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toyota Camry 2024',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Policy #: INS-2024-001',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Coverage Amount',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          const Text(
            '\$50,000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/viewpolicies'),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFF2563eb),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----- Painter (kept same) -----
class InsuranceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final gradient = const LinearGradient(
      colors: [Color(0xFF2563eb), Color(0xFF1d4ed8)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    paint.shader = gradient;

    final path = Path();
    final points = [0.3, 0.35, 0.32, 0.38, 0.36, 0.40, 0.38, 0.42, 0.40, 0.41];

    if (points.isEmpty) return;
    path.moveTo(0, size.height * (1 - points[0]));

    for (int i = 1; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height * (1 - points[i]);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2563eb), Color(0x002563eb)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    for (int i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height * (1 - points[i]);

      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = const Color(0xFF2563eb)
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
