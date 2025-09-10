import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class ProductsRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getProducts({int? categoryId}) {
    String endpoint = 'products';
    if (categoryId != null) {
      endpoint += '?category_id=$categoryId';
    }
    return _apiClient.get(endpoint);
  }
  
  Future<Response> getProductDetail(int productId) {
    return _apiClient.get('users/product_detail?product_id=$productId');
  }
  
  Future<Response> getFeaturedProducts() {
    return _apiClient.get('products?is_featured=1');
  }
  
  Future<Response> getRecommendedProducts() {
    return _apiClient.get('products?is_recommended=1');
  }
}