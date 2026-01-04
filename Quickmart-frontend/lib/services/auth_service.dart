import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.post('auth/login', {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password, {String? phone}) async {
    try {
      final requestBody = {
        'name': name,
        'email': email,
        'password': password,
      };
      
      if (phone != null && phone.isNotEmpty) {
        requestBody['phone'] = phone;
      }
      
      final response = await ApiService.post('auth/register', requestBody);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
