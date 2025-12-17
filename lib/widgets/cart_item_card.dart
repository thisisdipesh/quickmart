import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quantity_selector.dart';

class CartItemCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String price;
  final int quantity;
  final VoidCallback? onDelete;
  final Function(int)? onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    this.onDelete,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade100,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey.shade400,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: const Color(0xFF6F52ED),
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6F52ED),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Quantity Selector
          QuantitySelector(
            initialQuantity: quantity,
            onQuantityChanged: onQuantityChanged,
          ),

          const SizedBox(width: 12),

          // Delete Icon
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
