import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/api_product_model.dart';
import '../repositories/wishlist_repository.dart';

class WishlistController extends GetxController {
  WishlistRepository? _wishlistRepository;

  final isLoading = false.obs;
  final wishlistItems = <ApiProductModel>[].obs;
 // final int userId = 11; // Replace with actual user ID from auth
  GlobalController? _globalController;
  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
    // Don't auto-load wishlist - only load when WishlistView is opened
  }

  void _initializeServices() {
    try {
      _wishlistRepository = Get.find<WishlistRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing wishlist services: $e');
    }
  }

  Future<void> loadWishlist() async {
    if (_wishlistRepository == null) return;

    isLoading.value = true;
    int userIdInt = _globalController!.userId.value;
    try {
      final response = await _wishlistRepository!.getWishlist(userIdInt);

      if (response.isOk) {
        print('Wishlist API Response: ${response.body}');
        final List<dynamic> wishlistData = response.body['wishlist_items'] ?? [];
        wishlistItems.value = wishlistData.map((json) => ApiProductModel.fromJson({
          'product_id': json['product_id'],
          'name': json['name'],
          'price': json['price'],
          'original_price': json['original_price'],
          'image': json['image'],
          'unit': json['unit'],
          'weight': json['weight'],
          'rating': json['rating'],
          'is_featured': json['is_featured'],
          'is_recommended': json['is_recommended'],
          'category_name': json['category_name'],
          'discount_percentage': json['discount_percentage'],
        })).toList();
        print('Wishlist items loaded: ${wishlistItems.length}');
        update(); // Trigger UI update
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load wishlist');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToWishlist(int productId) async {
    if (_wishlistRepository == null) return;
    int userIdInt = _globalController!.userId.value;
    try {
      final response = await _wishlistRepository!.addToWishlist(userIdInt, productId);
      print('Add to wishlist response: ${response.body}');

      if (response.isOk) {
        await loadWishlist(); // Refresh wishlist
        update(); // Trigger global UI update
        Get.snackbar('Success', response.body['message'] ?? 'Added to wishlist');
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      print('Add to wishlist error: $e');
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    if (_wishlistRepository == null) return;
    int userIdInt = _globalController!.userId.value;
    try {
      final response = await _wishlistRepository!.removeFromWishlist(userIdInt, productId);
      print('Remove from wishlist response: ${response.body}');

      if (response.isOk) {
        await loadWishlist(); // Refresh wishlist
        update(); // Trigger global UI update
        Get.snackbar('Success', response.body['message'] ?? 'Removed from wishlist');
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to remove from wishlist');
      }
    } catch (e) {
      print('Remove from wishlist error: $e');
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  bool isInWishlist(int productId) {
    return wishlistItems.any((item) => item.productId == productId);
  }
  
  Future<void> toggleWishlist(dynamic product) async {
    final productId = product.productId ?? product.id;
    
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }
}