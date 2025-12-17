import '../models/product_model.dart';

class ProductController {
  // Placeholder list for now (will be replaced with MongoDB calls)
  static List<ProductModel> _products = [];

  // Add a new product
  Future<void> addProduct(ProductModel product) async {
    // TODO: Implement MongoDB API call
    // Example: await ApiService.post('/products', product.toJson());

    // Placeholder: Add to local list
    _products.add(product);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    // TODO: Implement MongoDB API call
    // Example: final response = await ApiService.get('/products');
    // return (response as List).map((json) => ProductModel.fromJson(json)).toList();

    // Placeholder: Return local list
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_products);
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    // TODO: Implement MongoDB API call
    // Example: await ApiService.delete('/products/$productId');

    // Placeholder: Remove from local list
    _products.removeWhere((product) => product.id == productId);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Update a product
  Future<void> updateProduct(ProductModel product) async {
    // TODO: Implement MongoDB API call
    // Example: await ApiService.put('/products/${product.id}', product.toJson());

    // Placeholder: Update in local list
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

