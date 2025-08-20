import 'package:get/get.dart';
import '../modules/home/models/home_product_model.dart';

class WishlistController extends GetxController {
  RxList<HomeProductModel> wishlistItems = <HomeProductModel>[].obs;

  bool isInWishlist(int productId) {
    return wishlistItems.any((item) => item.id == productId);
  }

  void toggleWishlist(HomeProductModel product) {
    if (isInWishlist(product.id!)) {
      wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      wishlistItems.add(product);
    }
  }

  void removeFromWishlist(int productId) {
    wishlistItems.removeWhere((item) => item.id == productId);
  }
}