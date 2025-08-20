import 'package:get/get.dart';
import '../../modules/home/models/home_product_model.dart';
import '../../modules/home/data/all_products_data.dart';

class ProductDetailController extends GetxController {
  final HomeProductModel product = Get.arguments['product'];
  final int categoryId = Get.arguments['categoryId'];
  
  RxList<HomeProductModel> similarProducts = <HomeProductModel>[].obs;
  RxInt selectedVariantIndex = 0.obs;
  RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadSimilarProducts();
  }

  void loadSimilarProducts() {
    final allProducts = getAllProducts();
    similarProducts.value = allProducts
        .where((p) => p.categoryId == categoryId && p.id != product.id)
        .toList();
  }

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

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double get currentPrice {
    return product.variants[selectedVariantIndex.value].price * quantity.value;
  }

  String get currentUnit {
    return product.variants[selectedVariantIndex.value].unit;
  }
}
