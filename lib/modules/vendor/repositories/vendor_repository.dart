import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class VendorRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getCategories() {
    return _apiClient.get('vendor/categories_selection');
  }

  Future<Response> getUnits() {
    return _apiClient.get('vendor/units_selection');
  }

  Future<Response> addProduct(Map<String, dynamic> productData) {
    return _apiClient.post('vendor/add_product', productData);
  }

  Future<Response> getStockManagement(int vendorId, String type) {
    return _apiClient.get('vendor/stock_management?vendor_id=$vendorId&type=$type');
  }

  Future<Response> updateStock(int productId, int vendorId, int stockQuantity) {
    return _apiClient.post('vendor/update_stock', {
      'product_id': productId,
      'vendor_id': vendorId,
      'stock_quantity': stockQuantity,
    });
  }
}