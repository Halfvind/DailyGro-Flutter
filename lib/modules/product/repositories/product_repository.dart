import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class ProductRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getProducts({
    int? categoryId,
    int? vendorId,
    String? search,
    bool? featured,
    bool? recommended,
    int limit = 20,
    int offset = 0,
  }) {
    Map<String, String> params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
    };

    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (vendorId != null) params['vendor_id'] = vendorId.toString();
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (featured != null) params['featured'] = featured ? '1' : '0';
    if (recommended != null) params['recommended'] = recommended ? '1' : '0';

    String queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _apiClient.get('products?$queryString');
  }

  Future<Response> getProductDetail(int productId) {
    return _apiClient.get('products?product_id=$productId');
  }
}