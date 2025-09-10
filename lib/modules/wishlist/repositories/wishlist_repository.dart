import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class WishlistRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getWishlist(int userId) {
    return _apiClient.get('users/wishlist?user_id=$userId');
  }

  Future<Response> addToWishlist(int userId, int productId) {
    return _apiClient.post('users/wishlist', {
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<Response> removeFromWishlist(int userId, int productId) {
    return _apiClient.delete('users/wishlist', query: {
      'user_id': userId.toString(),
      'product_id': productId.toString(),

    });
  }
}