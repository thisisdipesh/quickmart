import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount => _cartItems.length;

  // Add item to cart
  void addToCart({
    required String productId,
    required String productName,
    required String productImage,
    required String price,
    required int quantity,
  }) {
    // Check if item already exists in cart
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item['productId'] == productId,
    );

    if (existingItemIndex >= 0) {
      // Update quantity if item exists
      _cartItems[existingItemIndex]['quantity'] =
          (_cartItems[existingItemIndex]['quantity'] as int) + quantity;
    } else {
      // Add new item
      _cartItems.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'productId': productId,
        'name': productName,
        'image': productImage,
        'price': price,
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  // Update quantity of an item
  void updateQuantity(String itemId, int newQuantity) {
    final itemIndex = _cartItems.indexWhere((item) => item['id'] == itemId);
    if (itemIndex >= 0) {
      if (newQuantity > 0) {
        _cartItems[itemIndex]['quantity'] = newQuantity;
      } else {
        _cartItems.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeFromCart(String itemId) {
    _cartItems.removeWhere((item) => item['id'] == itemId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Calculate total price
  double getTotalPrice() {
    double total = 0;
    for (var item in _cartItems) {
      final priceString = item['price'] as String;
      final price = _extractPrice(priceString);
      final quantity = item['quantity'] as int;
      total += price * quantity;
    }
    return total;
  }

  // Extract price from string like "Rs 450" or "Rs 450.50"
  double _extractPrice(String priceString) {
    try {
      final cleaned = priceString.replaceAll('Rs', '').replaceAll(' ', '').trim();
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  // Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;
}



