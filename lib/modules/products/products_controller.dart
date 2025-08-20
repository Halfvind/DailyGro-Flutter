import 'package:get/get.dart';
import '../home/models/home_product_model.dart';
import '../home/data/all_products_data.dart';

class ProductsController extends GetxController {
  RxList<HomeProductModel> products = <HomeProductModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFruits();
  }

  void loadFruits() {
    isLoading.value = true;
    products.value = getProductsByCategory(1); // Load fruits only
    isLoading.value = false;
  }
}