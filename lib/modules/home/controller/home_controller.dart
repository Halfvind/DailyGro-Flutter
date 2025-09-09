import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/all_products_data.dart';
import '../../../models/category_model.dart';
import '../../category/controllers/category_controller.dart';
import '../../product/controllers/product_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../models/home_product_model.dart';


class HomeController extends GetxController {
  // User info
  RxString userName = 'Aravind'.obs;

  // Location
  RxString selectedLocation = 'Visakhapatnam'.obs; // ✅ Added this line

  // Search
  final TextEditingController searchController = TextEditingController();
  RxString searchText = ''.obs;

  // Categories
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxInt selectedCategoryIndex = 0.obs;

  // Products
  RxList<HomeProductModel> featuredProducts = <HomeProductModel>[].obs;
  RxList<HomeProductModel> recommendedProducts = <HomeProductModel>[].obs;
  RxList<HomeProductModel> fruitProducts = <HomeProductModel>[].obs;

  // Wallet and vouchers
  RxDouble walletAmount = 1500.0.obs;
  RxInt voucherCount = 3.obs;

  // Loading
  RxBool isLoading = true.obs;

  // Getter for convenience
  List<CategoryModel> get categories => categoryList;

  final CategoryController categoryController = Get.put(CategoryController());
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  final WishlistController wishlistController = Get.put(WishlistController());
  final OrderController orderController = Get.put(OrderController());

  @override
  void onInit() {
    super.onInit();
    initializeHomeData();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Initialize API-based controllers
    cartController.loadCart();
    wishlistController.loadWishlist();
  }

  void initializeHomeData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay

    // Load categories from API
    await categoryController.loadCategories();
    categoryList.value = categoryController.categories;
    featuredProducts.value = getFeaturedProducts();
    recommendedProducts.value = getRecommendedProducts();

    // Only Fruits (categoryId = 1)
    fruitProducts.value = getProductsByCategory(1);

  /*  // If you want only recommended fruits
    fruitProducts.value = getProductsByCategory(1)
        .where((p) => p.isRecommended == true)
        .toList();*/

    walletAmount.value = 1500.0;
    voucherCount.value = 3;

    isLoading.value = false;
  }

  void updateSearchText(String value) {
    searchText.value = value;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void changeLocation(String location) {
    selectedLocation.value = location;
  }

  Future<void> refreshHomeData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate refresh
    initializeHomeData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

