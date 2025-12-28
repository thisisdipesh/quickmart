import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/search_bar.dart';
import '../widgets/offer_banner.dart';
import '../widgets/category_card.dart';
import '../widgets/featured_products_list.dart';
import '../pages/login_page.dart';
import '../pages/search_page.dart';
import '../pages/cart_page.dart';
import '../pages/profile_page.dart';
import '../pages/product_list_page.dart';
import '../pages/categories_list_page.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _categories = [];
  bool _categoriesLoading = true;

  final List<Map<String, dynamic>> _staticCategories = [
    {'icon': Icons.ac_unit, 'label': 'Frozen Meat'},
    {'icon': Icons.eco, 'label': 'Fresh Vegetables'},
    {'icon': Icons.home, 'label': 'Household Item'},
    {'icon': Icons.kitchen, 'label': 'Pantry Essentials'},
    {'icon': Icons.fastfood, 'label': 'Snacks'},
    {'icon': Icons.local_drink, 'label': 'Beverages'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await ApiService.get('categories');
      if (response['success'] == true && response['data'] != null) {
        final categories = response['data']['categories'] as List?;
        setState(() {
          _categories = categories?.map((c) => c as Map<String, dynamic>).toList() ?? [];
          _categoriesLoading = false;
        });
      } else {
        setState(() {
          _categories = _staticCategories;
          _categoriesLoading = false;
        });
      }
    } catch (e) {
      // Fallback to static categories if API fails
      setState(() {
        _categories = _staticCategories;
        _categoriesLoading = false;
      });
    }
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const CategoriesListPage();
      case 2:
        return const SearchPage();
      case 3:
        return const CartPage();
      case 4:
        return const ProfilePage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
            // Top Section with rounded container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // User info and icons row
                    Row(
                      children: [
                        // User Avatar
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // User greeting
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Hello!',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                UserService.getUserName(),
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Icons on right
                        IconButton(
                          onPressed: () {
                            // Navigate to wishlist (can be implemented later)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Wishlist feature coming soon!',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: const Color(0xFF7C3AED),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.grey.shade700,
                            size: 26,
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                        IconButton(
                          onPressed: () {
                            // Navigate to notifications (can be implemented later)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Notifications feature coming soon!',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: const Color(0xFF7C3AED),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.notifications_none,
                            color: Colors.grey.shade700,
                            size: 26,
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                        IconButton(
                          onPressed: () {
                            // Admin Panel access
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.grey.shade700,
                            size: 26,
                          ),
                          tooltip: 'Admin Panel',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ),
                        );
                      },
                      child: const CustomSearchBar(),
                    ),
                  ],
                ),
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Offer Banner Slider (moved above Featured Products)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: OfferBanner(),
                    ),
                    const SizedBox(height: 30),
                    // Featured Products Section
                    const FeaturedProductsList(),
                    const SizedBox(height: 30),
                    // Categories Section (moved below featured products)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductListPage(
                                    categoryName: 'All Categories',
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF7C3AED),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Categories Grid (2 rows, 3 per row)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _categoriesLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate item height based on width to prevent overflow
                                final itemWidth = (constraints.maxWidth - 32) / 3;
                                final itemHeight = itemWidth / 0.85;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.85,
                                    mainAxisExtent: itemHeight,
                                  ),
                                  itemCount: _categories.length > 6 ? 6 : _categories.length,
                              itemBuilder: (context, index) {
                                final category = _categories[index];
                                final categoryId = category['_id'] as String?;
                                final categoryName = category['name'] as String? ??
                                    category['label'] as String? ??
                                    'Category';
                                
                                // Check if category has iconUrl from API
                                if (category.containsKey('iconUrl') &&
                                    category['iconUrl'] != null) {
                                  // Use API category with icon
                                  return CategoryCard(
                                    iconData: Icons.category,
                                    label: categoryName,
                                    backgroundColor: Colors.white,
                                    iconUrl: category['iconUrl'] as String?,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductListPage(
                                            categoryId: categoryId,
                                            categoryName: categoryName,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  // Use static category with icon
                                  return CategoryCard(
                                    iconData: category['icon'] as IconData? ??
                                        Icons.category,
                                    label: categoryName,
                                    backgroundColor: Colors.white,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductListPage(
                                            categoryId: categoryId,
                                            categoryName: categoryName,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _getCurrentScreen(),
      // Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF7C3AED),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
