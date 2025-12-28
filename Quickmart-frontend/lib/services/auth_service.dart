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

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await ApiService.post('auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
