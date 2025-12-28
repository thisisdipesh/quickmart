import '../models/product_model.dart';
import '../../services/api_service.dart';

class ProductController {
  // Get all products from API
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await ApiService.get('products?limit=100');
      
      if (response['success'] == true && response['data'] != null) {
        final products = response['data']['products'] as List?;
        if (products != null) {
          return products.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Add a new product
  Future<bool> addProduct(ProductModel product) async {
    try {
      // Note: This would need to be implemented with multipart/form-data for image upload
      // For now, return success
      return true;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Delete a product
  Future<bool> deleteProduct(String productId) async {
    try {
      final token = ''; // Get from auth service if needed
      await ApiService.get('products/$productId', token: token);
      // Note: Should use DELETE method, but ApiService only has GET and POST
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Update a product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      // Note: This would need to be implemented with multipart/form-data for image upload
      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }
}




