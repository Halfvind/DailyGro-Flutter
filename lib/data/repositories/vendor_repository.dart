import 'package:get/get.dart';
import '../api/api_client.dart';

class VendorRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  Future<Map<String, dynamic>?> getDashboardData() async {
    try {
      final response = await _apiClient.getVendorDashboard();
      return response.isOk ? response.body : null;
    } catch (e) {
      return null;
    }
  }
  
  Future<List<dynamic>?> getProducts() async {
    try {
      final response = await _apiClient.getVendorProducts();
      return response.isOk ? response.body : null;
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.addProduct(productData);
      return response.isOk;
    } catch (e) {
      return false;
    }
  }
}