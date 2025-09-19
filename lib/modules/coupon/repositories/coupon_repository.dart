import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class CouponRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getCoupons(int userId) {
    print('CouponRepository: Making API call to users/coupons?user_id=$userId');
    return _apiClient.get('users/coupons?user_id=$userId');
  }
}
