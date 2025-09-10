/*
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/api/api_client.dart';
import '../../data/api/endpoints.dart';

class ProductsRepo {
  final ApiClient _apiClient = Get.find<ApiClient>();

  getProductsData() async {
    try {

      Future<Response> getProductsByCategory(categoryId) {
        return _apiClient.get('${ApiEndpoints.products}?category_id=$categoryId');
      }

      if (response.statusCode == 200) {
        return GetDashboardData.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      // throw Exception(e.message);
    } on SocketException catch (_) {
      debugPrint('not connected');
    }
  }

}*/
