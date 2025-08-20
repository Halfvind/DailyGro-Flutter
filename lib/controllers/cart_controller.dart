import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../modules/home/models/home_product_model.dart';
import 'integrated_order_controller.dart';
import 'orders_controller.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;

  double get totalAmount => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity.value);
  bool get hasItems => cartItems.isNotEmpty;

  void addToCart(HomeProductModel product, {int variantIndex = 0}) {
    final existingIndex = cartItems.indexWhere((item) => 
        item.product.id == product.id && 
        item.selectedVariantIndex.value == variantIndex);
    
    if (existingIndex != -1) {
      cartItems[existingIndex].updateQuantity(cartItems[existingIndex].quantity.value + 1);
    } else {
      cartItems.add(CartItem(
        product: product,
        quantity: 1,
        variantIndex: variantIndex,
      ));
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }

  void updateItemQuantity(int index, int quantity) {
    if (index >= 0 && index < cartItems.length) {
      if (quantity <= 0) {
        removeFromCart(index);
      } else {
        cartItems[index].updateQuantity(quantity);
      }
    }
  }

  void updateItemVariant(int index, int variantIndex) {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index].updateVariant(variantIndex);
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  bool isProductInCart(int productId, int variantIndex) {
    return cartItems.any((item) => 
        item.product.id == productId && 
        item.selectedVariantIndex.value == variantIndex);
  }

  int getProductQuantity(int productId, int variantIndex) {
    final item = cartItems.firstWhereOrNull((item) => 
        item.product.id == productId && 
        item.selectedVariantIndex.value == variantIndex);
    return item?.quantity.value ?? 0;
  }
  
  Future<String?> placeOrder({
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    if (cartItems.isEmpty) {
      Get.snackbar('Error', 'Cart is empty');
      return null;
    }

    try {
      isLoading.value = true;
      
      // Use integrated order system
      final integratedController = Get.find<IntegratedOrderController>();
      final orderId = integratedController.placeOrder(
        items: List<CartItem>.from(cartItems),
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        userId: 'user_001', // In real app, get from auth
      );
      
      // Also use existing order controller for user order history
      final ordersController = Get.find<OrdersController>();
      await ordersController.placeOrder(
        items: List<CartItem>.from(cartItems),
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
      );
      
      // Clear cart after successful order
      clearCart();
      return orderId;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
