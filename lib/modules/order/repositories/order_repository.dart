import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class OrderRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getOrders(int userId) {
    return _apiClient.get('users/orders?user_id=$userId');
  }

  Future<Response> createOrder({
    required int userId,
    required double totalAmount,
    required int addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) {
    var data ={
      'user_id': userId,
      'total_amount': totalAmount,
      'address_id': addressId,
      'payment_method': paymentMethod,
      'items': items,
    };

    print('creating order body data :$data');
    return _apiClient.post('users/orders', data);
  }

  Future<Response> getOrderTracking(int orderId) {
    return _apiClient.get('users/order_tracking?order_id=$orderId');
  }
}