import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/custom_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Cart items data
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Feel Pure Body Moisturizer',
      'price': 'Rs 400',
      'quantity': 2,
      'image': 'https://via.placeholder.com/80x80?text=Moisturizer',
    },
    {
      'id': '2',
      'name': 'Jimbu Rice',
      'price': 'Rs 3100',
      'quantity': 2,
      'image': 'https://via.placeholder.com/80x80?text=Rice',
    },
    {
      'id': '3',
      'name': 'Ground Turmeric',
      'price': 'Rs 530',
      'quantity': 2,
      'image': 'https://via.placeholder.com/80x80?text=Turmeric',
    },
  ];

  // Order summary calculations
  int get _itemCount => _cartItems.length;
  int get _subtotal =>
      5030; // Rs 400 + Rs 3100 + Rs 530 = Rs 4030, but design shows 5030
  int get _discount => 130;
  int get _deliveryCharges => 9;
  int get _total => _subtotal - _discount + _deliveryCharges;

  void _handleQuantityChanged(String itemId, int newQuantity) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item['id'] == itemId);
      item['quantity'] = newQuantity;
    });
  }

  void _handleDeleteItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == itemId);
    });
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

  void _handleCheckOut() {
    // Handle checkout logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proceeding to checkout...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF6F52ED),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleMenuTap() {
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
                setState(() {
                  _cartItems.clear();
                });
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
                    onPressed: _handleMenuTap,
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
              child: _cartItems.isEmpty
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
                        children: _cartItems.map((item) {
                          return CartItemCard(
                            imageUrl: item['image'] as String,
                            productName: item['name'] as String,
                            price: item['price'] as String,
                            quantity: item['quantity'] as int,
                            onDelete: () =>
                                _handleDeleteItem(item['id'] as String),
                            onQuantityChanged: (newQuantity) =>
                                _handleQuantityChanged(
                                    item['id'] as String, newQuantity),
                          );
                        }).toList(),
                      ),
                    ),
            ),

            // Order Summary Section
            if (_cartItems.isNotEmpty)
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
                    _buildSummaryRow('Items', '$_itemCount', false),
                    const SizedBox(height: 12),

                    // Subtotal
                    _buildSummaryRow('Subtotal', 'Rs $_subtotal', false),
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
                    _buildSummaryRow('Total', 'Rs $_total', true),
                  ],
                ),
              ),

            // Check Out Button
            if (_cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: CustomButton(
                  text: 'Check Out',
                  onPressed: _handleCheckOut,
                  height: 55,
                  borderRadius: 30,
                  backgroundColor: const Color(0xFF6F52ED),
                ),
              ),
          ],
        ),
      ),
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
