import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/custom_button.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';
import 'login_page.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Order summary calculations
  double _calculateSubtotal(CartService cartService) {
    return cartService.getTotalPrice();
  }

  int get _discount => 130;
  int get _deliveryCharges => 9;

  double _calculateTotal(CartService cartService) {
    return _calculateSubtotal(cartService) - _discount + _deliveryCharges;
  }

  void _handleQuantityChanged(CartService cartService, String itemId, int newQuantity) {
    cartService.updateQuantity(itemId, newQuantity);
  }

  void _handleDeleteItem(CartService cartService, String itemId, BuildContext context) {
    cartService.removeFromCart(itemId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Item removed from cart',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF6F52ED),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleCheckOut(BuildContext context) async {
    // Ensure initialization and check if user is logged in
    await UserService.ensureInitialized();
    if (!UserService.isLoggedIn()) {
      // Show dialog to redirect to login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Login Required',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You must be logged in to checkout. Please login or create an account to continue.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6F52ED),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // User is logged in, proceed with checkout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutPage(),
      ),
    );
  }

  void _handleMenuTap(CartService cartService, BuildContext context) {
    // Handle menu tap
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: Text(
                'Clear Cart',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Navigator.pop(context);
                cartService.clearCart();
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: Text(
                'Save for Later',
                style: GoogleFonts.poppins(),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        final cartItems = cartService.cartItems;
        final itemCount = cartService.itemCount;
        final subtotal = _calculateSubtotal(cartService);
        final total = _calculateTotal(cartService);

        return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top AppBar - White rounded container
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
                  // Back arrow
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey.shade800,
                      size: 24,
                    ),
                  ),
                  // Cart title
                  Text(
                    'Cart',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Vertical 3-dot menu
                  IconButton(
                    onPressed: () => _handleMenuTap(cartService, context),
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade800,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Cart Items List
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: cartItems.map((item) {
                          return CartItemCard(
                            imageUrl: item['image'] as String? ?? '',
                            productName: item['name'] as String? ?? '',
                            price: item['price'] as String? ?? 'Rs 0',
                            quantity: item['quantity'] as int? ?? 1,
                            onDelete: () =>
                                _handleDeleteItem(cartService, item['id'] as String, context),
                            onQuantityChanged: (newQuantity) =>
                                _handleQuantityChanged(
                                    cartService, item['id'] as String, newQuantity),
                          );
                        }).toList(),
                      ),
                    ),
            ),

            // Order Summary Section
            if (cartItems.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Order Summary Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Summary',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Items
                    _buildSummaryRow('Items', '$itemCount', false),
                    const SizedBox(height: 12),

                    // Subtotal
                    _buildSummaryRow('Subtotal', 'Rs ${subtotal.toStringAsFixed(0)}', false),
                    const SizedBox(height: 12),

                    // Discount
                    _buildSummaryRow('Discount', 'Rs $_discount', false),
                    const SizedBox(height: 12),

                    // Delivery Charges
                    _buildSummaryRow(
                        'Delivery Charges', 'Rs $_deliveryCharges', false),
                    const SizedBox(height: 16),

                    // Divider
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    const SizedBox(height: 16),

                    // Total
                    _buildSummaryRow('Total', 'Rs ${total.toStringAsFixed(0)}', true),
                  ],
                ),
              ),

            // Check Out Button
            if (cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: CustomButton(
                  text: 'Check Out',
                  onPressed: () => _handleCheckOut(context),
                  height: 55,
                  borderRadius: 30,
                  backgroundColor: const Color(0xFF6F52ED),
                ),
              ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF6F52ED) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
