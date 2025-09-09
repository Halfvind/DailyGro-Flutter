import 'package:get/get.dart';
import '../api_client.dart';

class VendorApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String businessAddress,
    String? businessType,
  }) {
    return _apiClient.registerVendor({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'business_name': businessName,
      'business_address': businessAddress,
      'business_type': businessType,
      'role': 'vendor',
    });
  }

  Future<Response> login({
    required String email,
    required String password,
  }) {
    print('=== VENDOR API SERVICE LOGIN ===');
    print('Email: $email');
    print('Role: vendor');
    
    final data = {
      'email': email,
      'password': password,
      'role': 'vendor',
    };
    print('Login data: $data');
    
    return _apiClient.login(data);
  }

  Future<Response> getDashboard() => _apiClient.getVendorDashboard();
  Future<Response> getProducts() => _apiClient.getVendorProducts();
}