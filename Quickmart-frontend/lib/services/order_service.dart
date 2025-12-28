import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class OrderService {
  // Base URL from API service
  static const String baseUrl = ApiService.baseUrl;

  // Helper method to get token (you may need to adjust based on your auth implementation)
  static Future<String?> _getToken() async {
    // TODO: Implement token retrieval from your auth storage
    // For now, returning null - update this based on your auth implementation
    return null;
  }

  // Get all orders for authenticated user
  static Future<Map<String, dynamic>> getMyOrders() async {
    try {
      final token = await _getToken();
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

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Get single order by ID
  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final token = await _getToken();
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch order');
      }
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  // Create new order
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
    required double subtotal,
    double discount = 0,
    double deliveryCharges = 0,
    required double total,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'items': items,
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
          'subtotal': subtotal,
          'discount': discount,
          'deliveryCharges': deliveryCharges,
          'total': total,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}

