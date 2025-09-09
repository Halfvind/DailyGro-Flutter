import 'package:get/get.dart';
import '../api_client.dart';

class UserApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? address,
  }) {
    print('=== USER REGISTRATION API ===');
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'role': 'user',
    };
    print('Registration data: $data');
    return _apiClient.registerUser(data);
  }

  Future<Response> login({
    required String email,
    required String password,
  }) {
    print('=== USER API SERVICE LOGIN ===');
    print('Email: $email');
    print('Role: user');
    
    final data = {
      'email': email,
      'password': password,
      'role': 'user',
    };
    print('Login data: $data');
    
    return _apiClient.login(data);
  }

  Future<Response> getProfile() => _apiClient.getUserProfile();
}