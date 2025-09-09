import 'package:get/get.dart';
import 'endpoints.dart';

class ApiClient extends GetConnect {
  @override
  void onInit() {
    print('=== API CLIENT INIT ===');
    print('Base URL: ${ApiEndpoints.baseUrl}');

    baseUrl = ApiEndpoints.baseUrl;
    timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      print('REQUEST: ${request.method} ${request.url}');
      print('Headers: ${request.headers}');
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier<dynamic>((request, response) {
      print('RESPONSE: ${response.statusCode} ${response.statusText}');
      print('Response body: ${response.body}');
      return response;
    });

    super.onInit();
  }

  // Auth methods
  Future<Response> login(Map<String, dynamic> data) => post(ApiEndpoints.login, data);
  Future<Response> registerUser(Map<String, dynamic> data) {
    print('user body data $data');
    return post(ApiEndpoints.userRegister, data);
  }

  Future<Response> registerVendor(Map<String, dynamic> data) {
    print('vendor body data $data');
    return post(ApiEndpoints.vendorRegister, data);
  }

  Future<Response> registerRider(Map<String, dynamic> data) {
    print('rider body data $data');
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
