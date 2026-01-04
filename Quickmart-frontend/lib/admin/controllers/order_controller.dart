import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';

class OrderController {
  static const String baseUrl = ApiService.baseUrl;

  // Get all orders (admin only)
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final token = ''; // TODO: Get from auth service
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']['orders'] ?? []);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String status, {String? driverName, String? deliveryTime}) async {
    try {
      final token = ''; // TODO: Get from auth service
      final body = <String, dynamic>{
        'orderStatus': status,
      };
      if (driverName != null) body['driverName'] = driverName;
      if (deliveryTime != null) body['deliveryTime'] = deliveryTime;

      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  // Delete order
  Future<bool> deleteOrder(String orderId) async {
    try {
      final token = ''; // TODO: Get from auth service
      final response = await http.delete(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }
}



