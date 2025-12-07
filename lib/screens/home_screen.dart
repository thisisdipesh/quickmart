import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/search_bar.dart';
import '../widgets/offer_banner.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.ac_unit, 'label': 'Frozen Meat'},
    {'icon': Icons.eco, 'label': 'Fresh Vegetables'},
    {'icon': Icons.home, 'label': 'Household Item'},
    {'icon': Icons.kitchen, 'label': 'Pantry Essentials'},
    {'icon': Icons.fastfood, 'label': 'Snacks'},
    {'icon': Icons.local_drink, 'label': 'Beverages'},
  ];

  final List<Map<String, dynamic>> _featuredProducts = [
    {
      'name': 'Fresh Salt',
      'price': 'Rs 120',
      'image': '',
    },
    {
      'name': 'Basmati Rice',
      'price': 'Rs 3000',
      'image': '',
    },
    {
      'name': 'Jumla Brown Rice',
      'price': 'Rs 333',
      'image': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
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
                        ClipRRect(
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
                        const SizedBox(width: 16),
                        // User greeting
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                'Dipesh',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icons on right
                        IconButton(
                          onPressed: () {
                            // Wishlist action
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.grey.shade700,
                            size: 28,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Notification action
                          },
                          icon: Icon(
                            Icons.notifications_none,
                            color: Colors.grey.shade700,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    const CustomSearchBar(),
                  ],
                ),
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Offer Banner Slider
                      const OfferBanner(),
                      const SizedBox(height: 30),
                      // Categories Section
                      Row(
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
                              // See all categories
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
                      const SizedBox(height: 16),
                      // Categories Grid (2 rows, 3 per row)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            iconData: _categories[index]['icon'] as IconData,
                            label: _categories[index]['label'] as String,
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      // Featured Items Section
                      Text(
                        'Featured',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Featured Products List
                      SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _featuredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              imageUrl: _featuredProducts[index]['image'] as String,
                              name: _featuredProducts[index]['name'] as String,
                              price: _featuredProducts[index]['price'] as String,
                              onTap: () {
                                // Product tap action
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

