import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/category_card.dart';
import '../services/api_service.dart';
import 'product_list_page.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({super.key});

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String? _error;

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.get('categories');
      if (response['success'] == true && response['data'] != null) {
        final categories = response['data']['categories'] as List?;
        setState(() {
          _categories = categories?.map((c) => c as Map<String, dynamic>).toList() ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _categories = _staticCategories;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to static categories if API fails
      setState(() {
        _categories = _staticCategories;
        _isLoading = false;
      });
    }
  }

  void _navigateToCategoryProducts(Map<String, dynamic> category) {
    final categoryId = category['_id'] as String?;
    final categoryName = category['name'] as String? ??
        category['label'] as String? ??
        'Category';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListPage(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF7C3AED),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load categories',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _fetchCategories,
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No categories found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
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
                            onTap: () => _navigateToCategoryProducts(category),
                          );
                        } else {
                          // Use static category with icon
                          return CategoryCard(
                            iconData: category['icon'] as IconData? ??
                                Icons.category,
                            label: categoryName,
                            backgroundColor: Colors.white,
                            onTap: () => _navigateToCategoryProducts(category),
                          );
                        }
                      },
                    ),
    );
  }
}




