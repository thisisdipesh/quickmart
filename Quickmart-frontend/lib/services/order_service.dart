import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'user_service.dart';

class OrderService {
  // Base URL from API service
  static const String baseUrl = ApiService.baseUrl;

  // Place a new order
  static Future<Map<String, dynamic>> placeOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    required Map<String, double> location,
  }) async {
    try {
      final token = UserService.getToken();
      
      if (token == null) {
        throw Exception('User not authenticated. Please login first.');
      }

      final requestBody = {
        'items': items.map((item) => {
          'productId': item['id'] ?? item['productId'],
          'name': item['name'],
          'price': item['price'] is String 
              ? double.parse(item['price'].toString().replaceAll('Rs ', '').replaceAll(',', ''))
              : item['price'],
          'quantity': item['quantity'],
        }).toList(),
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'location': {
          'lat': location['lat'],
          'lng': location['lng'],
        },
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw Exception(body['message'] ?? 'Failed to place order');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Get all orders for authenticated user
  static Future<Map<String, dynamic>> getMyOrders() async {
    try {
      final token = UserService.getToken();
      
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/orders/user/my-orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw Exception(body['message'] ?? 'Failed to fetch orders');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Get single order by ID
  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final token = UserService.getToken();
      
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw Exception(body['message'] ?? 'Failed to fetch order');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Get user orders with optional status filter
  // status: 'active', 'completed', 'cancel', or null for all
  static Future<Map<String, dynamic>> getMyOrdersWithFilter({String? status}) async {
    try {
      final token = UserService.getToken();
      
      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Build query parameters
      final uri = status != null 
          ? Uri.parse('$baseUrl/orders/my?status=$status')
          : Uri.parse('$baseUrl/orders/my');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw Exception(body['message'] ?? 'Failed to fetch orders');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
