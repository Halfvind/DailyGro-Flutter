import 'package:get/get.dart';
import '../../../models/api_product_model.dart';
import '../repositories/products_repository.dart';

class ProductsController extends GetxController {
  ProductsRepository? _productsRepository;

  final isLoading = false.obs;
  final products = <ApiProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
    try {
      _productsRepository = Get.find<ProductsRepository>();
    } catch (e) {
      print('Error initializing products services: $e');
    }
  }

  Future<void> loadProducts({int? categoryId}) async {
    if (_productsRepository == null) return;

    isLoading.value = true;

    try {
      final response = await _productsRepository!.getProducts(categoryId: categoryId);

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        products.value = productList.map((json) => ApiProductModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadFeaturedProducts() async {
    if (_productsRepository == null) return;

    isLoading.value = true;

    try {
      final response = await _productsRepository!.getFeaturedProducts();

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        products.value = productList.map((json) => ApiProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading featured products: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadRecommendedProducts() async {
    if (_productsRepository == null) return;

    isLoading.value = true;

    try {
      final response = await _productsRepository!.getRecommendedProducts();

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        products.value = productList.map((json) => ApiProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading recommended products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}