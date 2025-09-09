import 'package:get/get.dart';
import '../api_client.dart';

class ProfileApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getUserProfile(String userId) {
    print('=== GET USER PROFILE API ===');
    print('User ID: $userId');
    
    return _apiClient.get('users/get_user_profile?id=$userId');

  }

  Future<Response> updateUserProfile(String userId, Map<String, dynamic> data) {
    print('=== UPDATE USER PROFILE API ===');
    print('User ID: $userId');
    print('Update data: $data');
    
    return _apiClient.put('user_registration', {
      'id': userId,
      ...data,
    });
  }
}