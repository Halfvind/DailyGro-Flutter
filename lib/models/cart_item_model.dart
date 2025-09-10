import 'package:get/get.dart';

class CartItem {
  final int productId;
  final String productName;
  final double price;
  final RxInt quantity;
  final int cartId;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.cartId,
    int quantity = 1,
  }) : quantity = quantity.obs;

  double get totalPrice => price * quantity.value;

  void updateQuantity(int newQuantity) {
    if (newQuantity > 0) {
      quantity.value = newQuantity;
    }
  }
}