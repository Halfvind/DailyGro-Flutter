import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../../../data/api/endpoints.dart';

class RiderRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getRiderProfile(String userId) {
    return _apiClient.get('${ApiEndpoints.riderProfile}?id=$userId');
  }

  Future<Response> updateRiderProfile(String userId, Map<String, dynamic> data) {
    return _apiClient.put(ApiEndpoints.riderUpdate, {
      'id': userId,
      'role': 'rider',
      ...data,
    });
  }

  Future<Response> registerRider(Map<String, dynamic> data) {
    return _apiClient.post(ApiEndpoints.riderRegister, {
      'role': 'rider',
      ...data,
    });
  }
}