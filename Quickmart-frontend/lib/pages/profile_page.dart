import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';
import 'login_page.dart';
import 'my_orders_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String get _userName {
    final fullName = UserService.getFullUserName() ?? 'User';
    return fullName;
  }

  String get _userEmail {
    return UserService.getUserEmail() ?? 'user@quickmart.com';
  }

  Future<void> _handleSignOut() async {
    // Clear user data from persistent storage
    await UserService.clearUserData();
    
    // Navigate to login page
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  void _handleMenuTap(String menuItem) {
    switch (menuItem) {
      case 'Order':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyOrdersPage(),
          ),
        );
        break;
      case 'Profile':
        // Already on profile page, do nothing or show edit dialog
        break;
      case 'Setting':
        // Navigate to settings page (if exists) or show placeholder
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Settings page coming soon',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF6C63FF),
          ),
        );
        break;
      case 'Help':
        // Navigate to help page (if exists) or show placeholder
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Help page coming soon',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF6C63FF),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Circular profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: const Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User name (bold)
                  Text(
                    _userName,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User email (light text)
                  Text(
                    _userEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu List Section
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    _buildMenuTile(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () => _handleMenuTap('Profile'),
                    ),
                    _buildMenuTile(
                      icon: Icons.settings_outlined,
                      title: 'Setting',
                      onTap: () => _handleMenuTap('Setting'),
                    ),
                    _buildMenuTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Order',
                      onTap: () => _handleMenuTap('Order'),
                    ),
                    _buildMenuTile(
                      icon: Icons.help_outline,
                      title: 'Help',
                      onTap: () => _handleMenuTap('Help'),
                    ),
                  ],
                ),
              ),
            ),

            // Sign Out Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: TextButton(
                  onPressed: _handleSignOut,
                  child: Text(
                    'Sign Out',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black87,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
