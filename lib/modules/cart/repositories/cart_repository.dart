import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class CartRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getCart(int userId) {
    return _apiClient.get('users/cart?user_id=$userId');
  }

  Future<Response> addToCart(int userId, int productId, int quantity) {
   var bodydata={
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
   print("ADD TO CART BODY DATA $bodydata");
    return _apiClient.post('users/cart',bodydata );
  }

  Future<Response> updateCartItem(int cartId, int quantity) {
    return _apiClient.put('users/cart', {
      'cart_id': cartId,
      'quantity': quantity,
    });
  }

  Future<Response> removeFromCart(int cartId) {
    return _apiClient.delete('users/cart?cart_id=$cartId');
  }
}