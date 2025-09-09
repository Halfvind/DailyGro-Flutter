import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../../../data/api/endpoints.dart';

class VendorRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getVendorProfile(String userId) {
    return _apiClient.get('${ApiEndpoints.vendorProfile}?id=$userId');
  }

  Future<Response> updateVendorProfile(String userId, Map<String, dynamic> data) {
    return _apiClient.put(ApiEndpoints.vendorUpdate, {
      'id': userId,
      'role': 'vendor',
      ...data,
    });
  }

  Future<Response> registerVendor(Map<String, dynamic> data) {
    return _apiClient.post(ApiEndpoints.vendorRegister, {
      'role': 'vendor',
      ...data,
    });
  }

  Future<Response> getDashboardData() {
    return _apiClient.get(ApiEndpoints.vendorDashboard);
  }

  Future<Response> getProducts() {
    return _apiClient.get(ApiEndpoints.vendorProducts);
  }
}