import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class BottomTabs extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomTabs({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          onTap(index);
          _navigateToScreen(context, index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 11,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.dashboard_outlined, 0),
            activeIcon: _buildActiveIcon(Icons.dashboard, 0),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.description_outlined, 1),
            activeIcon: _buildActiveIcon(Icons.description, 1),
            label: "Claims",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.chat_bubble_outline, 2),
            activeIcon: _buildActiveIcon(Icons.chat_bubble, 2),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person_outline, 3),
            activeIcon: _buildActiveIcon(Icons.person, 3),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return Icon(icon, size: 24);
  }

  Widget _buildActiveIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 24),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/claimlist');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}

// ALTERNATIVE APPROACH: Main Screen with PageView
// Use this if you want to keep state and avoid rebuilding screens

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Import your actual screen widgets
  final List<Widget> _screens = const [
    DashboardPlaceholder(),
    ClaimsPlaceholder(),
    ChatPlaceholder(),
    ProfilePlaceholder(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _screens,
      ),
      bottomNavigationBar: BottomTabs(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// Placeholder screens - Replace with your actual screens
class DashboardPlaceholder extends StatelessWidget {
  const DashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }
}

class ClaimsPlaceholder extends StatelessWidget {
  const ClaimsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claims'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Claims Screen'),
      ),
    );
  }
}

class ChatPlaceholder extends StatelessWidget {
  const ChatPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}