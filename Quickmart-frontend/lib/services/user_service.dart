import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static String? _userName;
  static String? _userEmail;
  static String? _userToken;
  static bool _initialized = false;
  
  // Initialize and load user data from storage
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name');
      _userEmail = prefs.getString('user_email');
      _userToken = prefs.getString('user_token');
      
      // Debug: Print loaded values (can be removed in production)
      // print('UserService initialized - Name: $_userName, Email: $_userEmail, HasToken: ${_userToken != null}');
      
      _initialized = true;
    } catch (e) {
      // Handle error silently
      _initialized = true;
    }
  }
  
  // Get user name (first name only)
  static String getUserName() {
    if (_userName == null) {
      return 'User';
    }
    // Extract first name if full name is provided
    final nameParts = _userName!.split(' ');
    return nameParts.first;
  }
  
  // Get full user name
  static String? getFullUserName() {
    return _userName;
  }
  
  // Get user email
  static String? getUserEmail() {
    return _userEmail;
  }
  
  // Set user data after login (with persistent storage)
  static Future<void> setUserData(String? name, String? email, {String? token}) async {
    // Set in-memory values first
    _userName = name;
    _userEmail = email;
    if (token != null) {
      _userToken = token;
    }
    
    // Save to persistent storage
    try {
      final prefs = await SharedPreferences.getInstance();
      if (name != null) {
        await prefs.setString('user_name', name);
      } else {
        await prefs.remove('user_name');
      }
      if (email != null) {
        await prefs.setString('user_email', email);
      } else {
        await prefs.remove('user_email');
      }
      if (token != null && token.isNotEmpty) {
        await prefs.setString('user_token', token);
      } else {
        await prefs.remove('user_token');
      }
      
      // Ensure initialized flag is set
      _initialized = true;
      
      // Debug: Verify save (can be removed in production)
      // final savedToken = prefs.getString('user_token');
      // print('UserService - Data saved. Token saved: ${savedToken != null && savedToken.isNotEmpty}');
    } catch (e) {
      // Handle error silently
    }
  }
  
  // Get JWT token
  static String? getToken() {
    return _userToken;
  }
  
  // Clear user data on logout (with persistent storage clearing)
  static Future<void> clearUserData() async {
    _userName = null;
    _userEmail = null;
    _userToken = null;
    
    // Clear from persistent storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('user_token');
    } catch (e) {
      // Handle error silently
    }
  }
  
  // Check if user is logged in (synchronous check - use after initialization)
  static bool isLoggedIn() {
    // If not initialized, try to get values directly from storage (synchronous check)
    // This handles cases where initialization might not have completed
    if (!_initialized) {
      // Return false if not initialized - caller should use isLoggedInAsync for accurate check
      return false;
    }
    // Check both in-memory and validate token exists
    final hasData = _userName != null && _userToken != null && _userToken!.isNotEmpty;
    return hasData;
  }
  
  // Async check if user is logged in (ensures initialization)
  static Future<bool> isLoggedInAsync() async {
    await ensureInitialized();
    return isLoggedIn();
  }
  
  // Ensure user service is initialized (for async operations)
  static Future<void> ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }
  
  // Force reload from storage (useful after login)
  static Future<void> reload() async {
    _initialized = false;
    await initialize();
  }
}

