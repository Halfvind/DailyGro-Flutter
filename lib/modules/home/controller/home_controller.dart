import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cart/repositories/cart_repository.dart';
import '../../order/repositories/order_repository.dart';
import '../../wishlist/repositories/wishlist_repository.dart';
import '../../../models/category_model.dart';
import '../../category/controllers/category_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../../coupon/controllers/coupon_controller.dart';
import '../../wallet/controllers/wallet_controller.dart';


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

  // Products - removed static data, now using API

  // Wallet and vouchers
  RxDouble walletAmount = 1500.0.obs;
  RxInt voucherCount = 3.obs;

  // Loading
  RxBool isLoading = true.obs;

  // Getter for convenience
  List<CategoryModel> get categories => categoryList;

  final CategoryController categoryController = Get.put(CategoryController());
  
  // Initialize repositories and controllers
  late final CartController cartController;
  late final WishlistController wishlistController;
  late final OrderController orderController;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    initializeHomeData();
  }
  
  void _initializeServices() {
    // Initialize repositories first
    Get.put(CartRepository());
    Get.put(WishlistRepository());
    Get.put(OrderRepository());
    
    // Then initialize controllers (without auto-loading data)
    cartController = Get.put(CartController());
    wishlistController = Get.put(WishlistController());
    orderController = Get.put(OrderController());
    
    // Initialize new controllers
    Get.put(CouponController());
    Get.put(WalletController());
  }
  


  void initializeHomeData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay

    // Load categories from API
    await categoryController.loadCategories();
    categoryList.value = categoryController.categories;

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

