import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'featured_product_card.dart';
import '../services/product_service.dart';
import '../pages/product_detail_page.dart';

class FeaturedProductsList extends StatefulWidget {
  const FeaturedProductsList({super.key});

  @override
  State<FeaturedProductsList> createState() => _FeaturedProductsListState();
}

class _FeaturedProductsListState extends State<FeaturedProductsList> {
  List<Map<String, dynamic>> _featuredProducts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedProducts();
  }

  Future<void> _fetchFeaturedProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await ProductService.getFeaturedProducts();
      setState(() {
        _featuredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productId: product['_id'] as String?,
          productName: product['name'] as String?,
          productPrice: product['price'] != null
              ? 'Rs ${(product['price'] as num).toStringAsFixed(0)}'
              : 'Rs 0',
          productImage: ProductService.getImageUrl(product['imageUrl'] as String?),
          productDescription: product['description'] as String?,
          rating: (product['rating'] as num?)?.toDouble(),
          inStock: ((product['stock'] as num?)?.toInt() ?? 0) > 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF7C3AED),
          ),
        ),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load featured products',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _fetchFeaturedProducts,
                child: Text(
                  'Retry',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_featuredProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: const Color(0xFFFF6B35),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Featured Products',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal Scrollable List
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _featuredProducts.length,
            itemBuilder: (context, index) {
              return FeaturedProductCard(
                product: _featuredProducts[index],
                onTap: () => _navigateToProductDetail(_featuredProducts[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

