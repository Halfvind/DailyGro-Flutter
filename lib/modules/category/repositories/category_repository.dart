import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class CategoryRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getCategories() {
    return _apiClient.get('categories');
  }
}