import '../services/api_service.dart';

class ProductService {
  // Fetch all products
  static Future<List<Map<String, dynamic>>> getAllProducts({
    String? category,
    String? search,
    bool? featured,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null) {
        queryParams['category'] = category;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (featured != null && featured) {
        queryParams['featured'] = 'true';
      }

      final queryString = queryParams.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final response = await ApiService.get('products?$queryString');

      if (response['success'] == true && response['data'] != null) {
        final products = response['data']['products'] as List?;
        return products?.map((p) => p as Map<String, dynamic>).toList() ?? [];
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Fetch featured products
  static Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    return getAllProducts(featured: true, limit: 20);
  }

  // Fetch product by ID
  static Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      final response = await ApiService.get('products/$id');

      if (response['success'] == true && response['data'] != null) {
        return response['data']['product'] as Map<String, dynamic>?;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  // Get image URL helper
  static String getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }

    // If already a full URL, return as is
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }

    // Otherwise, prepend base URL
    const baseUrl = 'http://10.0.2.2:5000';
    return '$baseUrl$imageUrl';
  }
}



