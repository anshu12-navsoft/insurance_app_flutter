import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../screens/policy_details.dart';

class ViewPoliciesScreen extends StatefulWidget {
  const ViewPoliciesScreen({super.key});

  @override
  State<ViewPoliciesScreen> createState() => _ViewPoliciesScreenState();
}

class _ViewPoliciesScreenState extends State<ViewPoliciesScreen> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  String _selectedFilter = 'All';

  final List<PolicyItem> dummyPolicies = [
    PolicyItem(
      policyNumber: "POL123456",
      type: PolicyType.health,
      status: PolicyStatus.active,
      premium: 200,
      coverageAmount: "500,000",
      startDate: DateTime(2024, 1, 15),
      endDate: DateTime(2025, 1, 14),
      holderName: "John Doe",
    ),
    PolicyItem(
      policyNumber: "POL654321",
      type: PolicyType.car,
      status: PolicyStatus.active,
      premium: 150,
      coverageAmount: "50,000",
      startDate: DateTime(2024, 3, 1),
      endDate: DateTime(2025, 2, 28),
      holderName: "John Doe",
    ),
    PolicyItem(
      policyNumber: "POL987654",
      type: PolicyType.life,
      status: PolicyStatus.active,
      premium: 100,
      coverageAmount: "1,000,000",
      startDate: DateTime(2023, 6, 10),
      endDate: DateTime(2033, 6, 9),
      holderName: "John Doe",
    ),
    PolicyItem(
      policyNumber: "POL456789",
      type: PolicyType.home,
      status: PolicyStatus.expiring,
      premium: 180,
      coverageAmount: "350,000",
      startDate: DateTime(2023, 12, 1),
      endDate: DateTime(2024, 12, 31),
      holderName: "John Doe",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  List<PolicyItem> get _filteredPolicies {
    if (_selectedFilter == 'All') return dummyPolicies;
    return dummyPolicies.where((policy) => 
      policy.status.displayName == _selectedFilter
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 900;
        
        if (isWeb) {
          return _buildWebLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'My Policies',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsOverview(),
          _buildFilterChips(),
          Expanded(
            child: _filteredPolicies.isEmpty
                ? _buildEmptyState()
                : _buildPoliciesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addpolicy');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Policy'),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'My Policies',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Policies List
          Expanded(
            flex: 6,
            child: Column(
              children: [
                // Add Policy Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addpolicy');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.add, size: 24),
                    label: const Text(
                      'Add New Policy',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                // Search and Filter Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search policies...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _showFilterSheet,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filter'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Filter Chips
                _buildFilterChips(),
                
                const SizedBox(height: 8),
                
                // Policies List
                Expanded(
                  child: _filteredPolicies.isEmpty
                      ? _buildEmptyState()
                      : _buildPoliciesList(),
                ),
              ],
            ),
          ),
          
          // Right side - Overview
          Expanded(
            flex: 4,
            child: Container(
              height: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsOverview(),
                    const SizedBox(height: 24),
                    _buildQuickStats(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalPolicies = dummyPolicies.length;
    final activePolicies = dummyPolicies.where((p) => p.status == PolicyStatus.active).length;
    final expiringPolicies = dummyPolicies.where((p) => p.status == PolicyStatus.expiring).length;
    final expiredPolicies = dummyPolicies.where((p) => p.status == PolicyStatus.expired).length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'Total Policies',
          totalPolicies.toString(),
          Icons.shield,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Active Policies',
          activePolicies.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Expiring Soon',
          expiringPolicies.toString(),
          Icons.warning,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Expired',
          expiredPolicies.toString(),
          Icons.cancel,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    final totalPolicies = dummyPolicies.length;
    final activePolicies = dummyPolicies.where((p) => p.status == PolicyStatus.active).length;
    final totalPremium = dummyPolicies.fold<double>(0, (sum, p) => sum + p.premium);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Portfolio Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Total',
                value: totalPolicies.toString(),
                icon: Icons.shield,
              ),
              Container(width: 1, height: 40, color: Colors.white30),
              _StatItem(
                label: 'Active',
                value: activePolicies.toString(),
                icon: Icons.check_circle,
              ),
              Container(width: 1, height: 40, color: Colors.white30),
              _StatItem(
                label: 'Premium',
                value: '\$${totalPremium.toInt()}',
                icon: Icons.payments,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Expiring Soon', 'Expired'];
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPoliciesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPolicies.length,
      itemBuilder: (context, index) {
        final policy = _filteredPolicies[index];
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Interval(
              index * 0.1,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(animation),
            child: _PolicyCard(policy: policy),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No ${_selectedFilter.toLowerCase()} policies',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter Policies',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _FilterOption(
              title: 'All Policies',
              subtitle: 'Show all policies',
              icon: Icons.list,
              onTap: () {
                setState(() => _selectedFilter = 'All');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Active',
              subtitle: 'Currently active policies',
              icon: Icons.check_circle,
              onTap: () {
                setState(() => _selectedFilter = 'Active');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Expiring Soon',
              subtitle: 'Policies expiring within 30 days',
              icon: Icons.warning,
              onTap: () {
                setState(() => _selectedFilter = 'Expiring Soon');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final PolicyItem policy;

  const _PolicyCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PolicyDetailsScreen(
                  policy: {
                    "policyNumber": policy.policyNumber,
                    "type": policy.type.displayName,
                    "status": policy.status.displayName,
                    "premium": "\$${policy.premium}/month",
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: policy.type.gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: policy.type.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        policy.type.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy.type.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            policy.policyNumber,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: policy.status),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoColumn(
                        icon: Icons.payments,
                        label: 'Premium',
                        value: '\$${policy.premium}/mo',
                        color: Colors.green,
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _InfoColumn(
                        icon: Icons.shield,
                        label: 'Coverage',
                        value: '\$${policy.coverageAmount}',
                        color: Colors.blue,
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _InfoColumn(
                        icon: Icons.calendar_today,
                        label: 'Expires',
                        value: _formatDate(policy.endDate),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PolicyStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}

// Models
class PolicyItem {
  final String policyNumber;
  final PolicyType type;
  final PolicyStatus status;
  final double premium;
  final String coverageAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String holderName;

  PolicyItem({
    required this.policyNumber,
    required this.type,
    required this.status,
    required this.premium,
    required this.coverageAmount,
    required this.startDate,
    required this.endDate,
    required this.holderName,
  });
}

enum PolicyType {
  health,
  car,
  life,
  home;

  String get displayName {
    switch (this) {
      case PolicyType.health:
        return 'Health Insurance';
      case PolicyType.car:
        return 'Car Insurance';
      case PolicyType.life:
        return 'Life Insurance';
      case PolicyType.home:
        return 'Home Insurance';
    }
  }

  Color get color {
    switch (this) {
      case PolicyType.health:
        return const Color(0xFF667eea);
      case PolicyType.car:
        return const Color(0xFF4facfe);
      case PolicyType.life:
        return const Color(0xFF43e97b);
      case PolicyType.home:
        return const Color(0xFFfa709a);
    }
  }

  IconData get icon {
    switch (this) {
      case PolicyType.health:
        return Icons.favorite;
      case PolicyType.car:
        return Icons.directions_car;
      case PolicyType.life:
        return Icons.family_restroom;
      case PolicyType.home:
        return Icons.home;
    }
  }

  Gradient get gradient {
    switch (this) {
      case PolicyType.health:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        );
      case PolicyType.car:
        return const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        );
      case PolicyType.life:
        return const LinearGradient(
          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
        );
      case PolicyType.home:
        return const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
        );
    }
  }
}

enum PolicyStatus {
  active,
  expiring,
  expired;

  String get displayName {
    switch (this) {
      case PolicyStatus.active:
        return 'Active';
      case PolicyStatus.expiring:
        return 'Expiring Soon';
      case PolicyStatus.expired:
        return 'Expired';
    }
  }

  Color get color {
    switch (this) {
      case PolicyStatus.active:
        return Colors.green;
      case PolicyStatus.expiring:
        return Colors.orange;
      case PolicyStatus.expired:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case PolicyStatus.active:
        return Icons.check_circle;
      case PolicyStatus.expiring:
        return Icons.warning;
      case PolicyStatus.expired:
        return Icons.cancel;
    }
  }
}