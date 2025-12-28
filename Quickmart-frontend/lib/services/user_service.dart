class UserService {
  static String? _userName;
  static String? _userEmail;
  
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
  
  // Set user data after login
  static void setUserData(String? name, String? email) {
    _userName = name;
    _userEmail = email;
  }
  
  // Clear user data on logout
  static void clearUserData() {
    _userName = null;
    _userEmail = null;
  }
  
  // Check if user is logged in
  static bool isLoggedIn() {
    return _userName != null;
  }
}

