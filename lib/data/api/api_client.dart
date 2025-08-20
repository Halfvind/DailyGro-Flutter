import 'package:get/get.dart';

class ApiClient extends GetConnect {
  static const String apiBaseUrl = 'https://api.dailygro.com';
  
  @override
  void onInit() {
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Content-Type'] = 'application/json';
      return request;
    });
    
    super.onInit();
  }
  
  Future<Response> login(Map<String, dynamic> data) => post('/auth/login', data);
  Future<Response> getUserProfile() => get('/user/profile');
  Future<Response> getVendorDashboard() => get('/vendor/dashboard');
  Future<Response> getVendorProducts() => get('/vendor/products');
  Future<Response> addProduct(Map<String, dynamic> data) => post('/vendor/products', data);
  Future<Response> getRiderDashboard() => get('/rider/dashboard');
  Future<Response> getAssignedOrders() => get('/rider/orders');
  Future<Response> updateOrderStatus(String orderId, String status) => 
    put('/rider/orders/$orderId/status', {'status': status});
}