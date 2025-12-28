import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/admin_sidebar.dart';
import 'pages/dashboard_page.dart';
import 'pages/add_product_page.dart';
import 'pages/product_list_page.dart';
import 'pages/categories_page.dart';
import 'pages/orders_page.dart';
import '../screens/home_screen.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  String _currentPage = 'dashboard';

  void _onPageChanged(String page) {
    if (page == 'logout') {
      _handleLogout();
    } else {
      setState(() => _currentPage = page);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to main app
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentPage) {
      case 'dashboard':
        return const DashboardPage();
      case 'add_product':
        return const AddProductPage();
      case 'product_list':
        return const ProductListPage();
      case 'categories':
        return const CategoriesPage();
      case 'orders':
        return const OrdersPage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      // Mobile layout with drawer
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            'Quick Mart Admin',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        drawer: Drawer(
          child: AdminSidebar(
            currentPage: _currentPage,
            onPageChanged: (page) {
              Navigator.pop(context); // Close drawer
              _onPageChanged(page);
            },
          ),
        ),
        body: _getCurrentPage(),
      );
    } else {
      // Desktop/Tablet layout with fixed sidebar
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Row(
          children: [
            // Sidebar
            AdminSidebar(
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
            ),
            
            // Main Content
            Expanded(
              child: _getCurrentPage(),
            ),
          ],
        ),
      );
    }
  }
}

