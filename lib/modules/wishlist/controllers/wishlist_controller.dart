import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/wishlist_model.dart';
import '../../../models/product_model.dart';
import '../repositories/wishlist_repository.dart';

class WishlistController extends GetxController {
  WishlistRepository? _wishlistRepository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final wishlistItems = <WishlistModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
    if (_wishlistRepository != null && _globalController != null) {
      loadWishlist();
    }
  }

  void _initializeServices() {
    try {
      _wishlistRepository = Get.find<WishlistRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing wishlist services: $e');
      Future.delayed(Duration(milliseconds: 500), () {
        _initializeServices();
      });
    }
  }

  Future<void> loadWishlist() async {
    if (_wishlistRepository == null || _globalController == null) return;

    isLoading.value = true;

    try {
      final response = await _wishlistRepository!.getWishlist(_globalController!.userId);

      if (response.isOk) {
        final List<dynamic> items = response.body['wishlist_items'] ?? [];
        wishlistItems.value = items.map((json) => WishlistModel.fromJson(json)).toList();
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
    if (_wishlistRepository == null || _globalController == null) return;

    try {
      final response = await _wishlistRepository!.addToWishlist(_globalController!.userId, productId);

      if (response.isOk) {
        Get.snackbar('Success', response.body['message'] ?? 'Added to wishlist');
        loadWishlist();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    if (_wishlistRepository == null || _globalController == null) return;

    try {
      final response = await _wishlistRepository!.removeFromWishlist(_globalController!.userId, productId);

      if (response.isOk) {
        Get.snackbar('Success', response.body['message'] ?? 'Removed from wishlist');
        loadWishlist();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to remove from wishlist');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  bool isInWishlist(int productId) {
    return wishlistItems.any((item) => item.productId == productId);
  }
  
  Future<void> toggleWishlist(dynamic product) async {
    int productId;
    if (product is ProductModel) {
      productId = product.productId;
    } else {
      return;
    }
    
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }
}