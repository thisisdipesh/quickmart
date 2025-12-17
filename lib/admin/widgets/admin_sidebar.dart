import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSidebar extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageChanged;

  const AdminSidebar({
    super.key,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          // Logo/Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Mart',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  page: 'dashboard',
                ),
                _buildNavItem(
                  icon: Icons.add_circle_outline,
                  title: 'Add Product',
                  page: 'add_product',
                ),
                _buildNavItem(
                  icon: Icons.list,
                  title: 'Product List',
                  page: 'product_list',
                ),
                _buildNavItem(
                  icon: Icons.category,
                  title: 'Categories',
                  page: 'categories',
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildNavItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  page: 'logout',
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String page,
    bool isLogout = false,
  }) {
    final isActive = currentPage == page;
    final color = isLogout
        ? Colors.red
        : isActive
            ? const Color(0xFF7C3AED)
            : Colors.grey[700];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF7C3AED).withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: color,
          ),
        ),
        onTap: () => onPageChanged(page),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

