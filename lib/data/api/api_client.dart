import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';

class ApiClient extends GetConnect {
  @override
  void onInit() {
    print('=== API CLIENT INIT ===');
    print('Base URL: ${ApiEndpoints.baseUrl}');

    baseUrl = ApiEndpoints.baseUrl;
    timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      print('➡️ REQUEST: ${request.method} ${request.url}');
      print('📤 Headers: ${request.headers}');
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier<dynamic>((request, response) {
      print('⬅️ RESPONSE: ${response.statusCode} ${response.statusText}');
      print('📥 Response Body: ${response.body}');
      return response;
    });

    super.onInit();
  }

  /// ✅ Login with detailed logging and shared preference storage
  Future<Response> login(Map<String, dynamic> data) async {
    print('📡 Calling Login API: ${ApiEndpoints.login}');
    print('📤 Request Body: ${jsonEncode(data)}');

    final response = await post(ApiEndpoints.login, data);

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.isOk && response.body['status'] == 'success') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('login_data', jsonEncode(response.body['data']));
      print('✅ Login data saved to SharedPreferences.');
    } else {
      print('❌ Login failed: ${response.body['message'] ?? 'Unknown error'}');
    }

    return response;
  }

  Future<Response> registerUser(Map<String, dynamic> data) {
    print('👤 User Registration Body: $data');
    return post(ApiEndpoints.userRegister, data);
  }

  Future<Response> registerVendor(Map<String, dynamic> data) {
    print('🏢 Vendor Registration Body: $data');
    return post(ApiEndpoints.vendorRegister, data);
  }

  Future<Response> registerRider(Map<String, dynamic> data) {
    print('🏍️ Rider Registration Body: $data');
    return post(ApiEndpoints.riderRegister, data);
  }

  // User methods
  Future<Response> getUserProfile() => get('/user/profile');

  // Vendor methods
  Future<Response> getVendorDashboard() => get('/vendor/dashboard');
  Future<Response> getVendorProducts() => get('/vendor/products');
  Future<Response> addProduct(Map<String, dynamic> data) =>
      post('/vendor/products', data);

  // Rider methods
  Future<Response> getRiderDashboard() => get('/rider/dashboard');
  Future<Response> getAssignedOrders() => get('/rider/orders');
  Future<Response> updateOrderStatus(String orderId, String status) =>
      put('/rider/orders/$orderId/status', {'status': status});
}
