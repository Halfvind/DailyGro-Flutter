import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class AddressRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getAddresses(String userId) {
    return _apiClient.get('users/user_address?user_id=$userId');
  }

  Future<Response> addAddress(Map<String, dynamic> data) {
    return _apiClient.post('users/user_address', data);
  }

  Future<Response> updateAddress(int addressId, Map<String, dynamic> data) {
    return _apiClient.put('users/user_address', {
      'address_id': addressId,
      ...data,
    });
  }

  Future<Response> deleteAddress(int addressId) {
    return _apiClient.delete('users/user_address?address_id=$addressId');
  }
}