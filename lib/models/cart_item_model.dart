import 'package:get/get.dart';
import '../modules/home/models/home_product_model.dart';

class CartItem {
  final HomeProductModel product;
  final RxInt quantity;
  final RxInt selectedVariantIndex;

  CartItem({
    required this.product,
    int quantity = 1,
    int variantIndex = 0,
  }) : quantity = quantity.obs,
       selectedVariantIndex = variantIndex.obs;

  double get totalPrice => product.variants[selectedVariantIndex.value].price * quantity.value;
  String get currentUnit => product.variants[selectedVariantIndex.value].unit;
  double get unitPrice => product.variants[selectedVariantIndex.value].price;

  void updateVariant(int index) {
    if (index >= 0 && index < product.variants.length) {
      selectedVariantIndex.value = index;
    }
  }

  void updateQuantity(int newQuantity) {
    if (newQuantity > 0) {
      quantity.value = newQuantity;
    }
  }
}