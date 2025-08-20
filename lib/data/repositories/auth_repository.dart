import 'package:get/get.dart';
import '../api/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  Future<Map<String, dynamic>?> login(String email, String password, String role) async {
    // Mock authentication for testing
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock credentials for testing
    final mockCredentials = {
      'user@dailygro.com': 'user123',
      'vendor@dailygro.com': 'vendor123', 
      'rider@dailygro.com': 'rider123',
      'admin@dailygro.com': 'admin123',
    };
    
    if (mockCredentials.containsKey(email) && mockCredentials[email] == password) {
      return {
        'success': true,
        'user': {
          'id': '1',
          'email': email,
          'role': role,
          'name': role.capitalize,
        },
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      };
    }
    
    return null; // Invalid credentials
  }
  
  Future<Map<String, dynamic>?> signup(Map<String, dynamic> signupData) async {
    // Mock signup for testing
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    String role = signupData['role'] ?? 'vendor';
    
    return {
      'success': true,
      'user': {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': signupData['email'],
        'role': role,
        'name': signupData['name'] ?? signupData['ownerName'],
        'shopName': signupData['shopName'],
      },
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    };
  }
  
  Future<bool> riderSignup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String address,
    required String vehicleType,
    required String vehicleNumber,
    required String licenseNumber,
    required String bankAccount,
    required String ifscCode,
  }) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    // In real app, this would make API call to register rider
    // For now, just return success
    return true;
  }
  
  Future<bool> logout() async {
    // Mock logout
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}