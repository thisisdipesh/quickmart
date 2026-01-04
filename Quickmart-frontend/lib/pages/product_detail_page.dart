import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/custom_button.dart';
import '../widgets/review_section.dart';
import '../services/cart_service.dart';
import '../pages/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final String? productId;
  final String? productName;
  final String? productPrice;
  final String? productImage;
  final String? productDescription;
  final double? rating;
  final int? reviewCount;
  final bool? inStock;

  const ProductDetailPage({
    super.key,
    this.productId,
    this.productName,
    this.productPrice,
    this.productImage,
    this.productDescription,
    this.rating,
    this.reviewCount,
    this.inStock,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    // Default values
    final productName = widget.productName ?? 'Product Name';
    final productPrice = widget.productPrice ?? 'Rs 230';
    final productImage = widget.productImage ??
        'https://via.placeholder.com/400x400?text=Product+Image';
    final productDescription = widget.productDescription ??
        'This is a detailed description of the product. It includes all the important information about the product features, benefits, and specifications. You can add more details here to help customers make informed purchasing decisions.';
    final rating = widget.rating ?? 4.5;
    final reviewCount = widget.reviewCount ?? 20;
    final inStock = widget.inStock ?? true;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Section - White rounded top container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back arrow icon
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey.shade800,
                      size: 24,
                    ),
                  ),
                  // Heart (wishlist) icon
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isWishlisted = !_isWishlisted;
                      });
                    },
                    icon: Icon(
                      _isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: _isWishlisted ? Colors.red : Colors.grey.shade800,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Product Image Section
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            productImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade100,
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFF6F52ED),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Product Information Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + Status + Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Expanded(
                                child: Text(
                                  productName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              // Status and Price Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // In Stock status
                                  Text(
                                    inStock ? 'In Stock' : 'Out of Stock',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: inStock
                                          ? Colors.grey.shade600
                                          : Colors.red.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Price
                                  Text(
                                    productPrice,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF6F52ED),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Rating Row
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                rating.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '($reviewCount Reviews)',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Description Section
                          Text(
                            'Description',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            productDescription,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Add Item Counter Section
                          Text(
                            'Add Item',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          QuantitySelector(
                            initialQuantity: _quantity,
                            onQuantityChanged: (newQuantity) {
                              setState(() {
                                _quantity = newQuantity;
                              });
                            },
                          ),

                          const SizedBox(height: 32),

                          // Reviews Section
                          ReviewSection(
                            productId: widget.productId ?? 'unknown',
                            currentRating: rating,
                            reviewCount: reviewCount,
                          ),

                          const SizedBox(
                              height: 100), // Space for bottom button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Add to Cart Button and Cart Icon
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to Cart Button
              Expanded(
                child: CustomButton(
                  text: 'Add to Cart',
                  onPressed: inStock
                      ? () {
                          final cartService = Provider.of<CartService>(context, listen: false);
                          final productId = widget.productId ?? 
                              DateTime.now().millisecondsSinceEpoch.toString();
                          
                          cartService.addToCart(
                            productId: productId,
                            productName: productName,
                            productImage: productImage,
                            price: productPrice,
                            quantity: _quantity,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added $_quantity item(s) to cart',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: const Color(0xFF6F52ED),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  backgroundColor: inStock ? const Color(0xFF6F52ED) : Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 12),
              // Cart Icon Button
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F52ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 24,
                      ),
                      // Cart item count badge
                      Consumer<CartService>(
                        builder: (context, cartService, child) {
                          if (cartService.itemCount > 0) {
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  cartService.itemCount.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
