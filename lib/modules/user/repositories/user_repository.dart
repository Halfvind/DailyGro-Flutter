import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../../../data/api/endpoints.dart';

class UserRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getUserProfile(String userId) {
    return _apiClient.get('${ApiEndpoints.userProfile}?id=$userId');
  }

  Future<Response> updateUserProfile(String userId, Map<String, dynamic> data) {
    return _apiClient.put(ApiEndpoints.userUpdate, {
      'id': userId,
      'role': 'user',
      ...data,
    });
  }

  Future<Response> registerUser(Map<String, dynamic> data) {
    return _apiClient.post(ApiEndpoints.userRegister, {
      'role': 'user',
      ...data,
    });
  }
}