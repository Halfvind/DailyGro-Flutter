import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/cart_model.dart';
import '../repositories/cart_repository.dart';

class CartController extends GetxController {
  CartRepository? _cartRepository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final cartItems = <CartModel>[].obs;
  final totalAmount = 0.0.obs;
  final itemCount = 0.obs;
  
  bool get hasItems => cartItems.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
    // Don't auto-load cart - only load when CartView is opened
  }

  void _initializeServices() {
    try {
      _cartRepository = Get.find<CartRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing cart services: $e');
    }
  }

  Future<void> loadCart() async {
    if (_cartRepository == null || _globalController == null) return;

    isLoading.value = true;

    try {
      final response = await _cartRepository!.getCart(_globalController!.userId);

      if (response.isOk) {
        final List<dynamic> items = response.body['cart_items'] ?? [];
        cartItems.value = items.map((json) => CartModel.fromJson(json)).toList();
        totalAmount.value = (response.body['total_amount'] ?? 0).toDouble();
        itemCount.value = response.body['item_count'] ?? 0;
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    if (_cartRepository == null || _globalController == null) return;

    try {
      final response = await _cartRepository!.addToCart(_globalController!.userId, productId, quantity);

      if (response.isOk) {
        Get.snackbar('Success', response.body['message'] ?? 'Added to cart');
        loadCart();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  Future<void> updateCartItem(int cartId, int quantity) async {
    if (_cartRepository == null) return;

    try {
      final response = await _cartRepository!.updateCartItem(cartId, quantity);

      if (response.isOk) {
        loadCart();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to update cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  Future<void> removeFromCart(int cartId) async {
    if (_cartRepository == null) return;

    try {
      final response = await _cartRepository!.removeFromCart(cartId);

      if (response.isOk) {
        Get.snackbar('Success', response.body['message'] ?? 'Removed from cart');
        loadCart();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to remove from cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    }
  }

  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
    itemCount.value = 0;
  }
  
  void updateItemQuantity(int index, int quantity) {
    if (index < cartItems.length) {
      final item = cartItems[index];
      updateCartItem(item.cartId, quantity);
    }
  }
  
  void updateItemVariant(int index, int variantIndex) {
    // Not applicable for API-based cart
  }
  
  int getProductQuantity(int productId, int variantIndex) {
    final item = cartItems.firstWhereOrNull((item) => item.productId == productId);
    return item?.quantity ?? 0;
  }
}