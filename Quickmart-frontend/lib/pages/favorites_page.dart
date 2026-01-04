import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/favorite_product_card.dart';
import 'product_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Sample favorite products data
  final List<Map<String, dynamic>> _favoriteProducts = [
    {
      'id': '1',
      'name': 'Premium Basmati Rice',
      'price': 'Rs 450',
      'image': 'https://via.placeholder.com/120',
    },
    {
      'id': '2',
      'name': 'Organic Honey',
      'price': 'Rs 350',
      'image': 'https://via.placeholder.com/120',
    },
    {
      'id': '3',
      'name': 'Extra Virgin Olive Oil',
      'price': 'Rs 680',
      'image': 'https://via.placeholder.com/120',
    },
    {
      'id': '4',
      'name': 'Organic Green Tea',
      'price': 'Rs 220',
      'image': 'https://via.placeholder.com/120',
    },
  ];

  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productId: product['id'] as String?,
          productName: product['name'] as String?,
          productPrice: product['price'] as String?,
          productImage: product['image'] as String?,
          productDescription: 'Premium quality product',
          rating: 4.5,
          inStock: true,
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.shade800,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Favorites',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: _favoriteProducts.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = _favoriteProducts[index];
                  return FavoriteProductCard(
                    id: product['id'] as String,
                    name: product['name'] as String,
                    price: product['price'] as String,
                    image: product['image'] as String,
                    onTap: () => _navigateToProductDetail(product),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding products to your favorites',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

