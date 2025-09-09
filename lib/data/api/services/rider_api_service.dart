import 'package:get/get.dart';
import '../api_client.dart';

class RiderApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String vehicleType,
    required String licenseNumber,
    String? address,
  }) {
    return _apiClient.registerRider({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'vehicle_type': vehicleType,
      'license_number': licenseNumber,
      'address': address,
      'role': 'rider',
    });
  }

  Future<Response> login({
    required String email,
    required String password,
  }) {
    print('=== RIDER API SERVICE LOGIN ===');
    print('Email: $email');
    print('Role: rider');
    
    final data = {
      'email': email,
      'password': password,
      'role': 'rider',
    };
    print('Login data: $data');
    
    return _apiClient.login(data);
  }

  Future<Response> getDashboard() => _apiClient.getRiderDashboard();
  Future<Response> getAssignedOrders() => _apiClient.getAssignedOrders();
}