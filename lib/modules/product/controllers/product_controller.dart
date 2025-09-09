import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductController extends GetxController {
  ProductRepository? _productRepository;

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final featuredProducts = <ProductModel>[].obs;
  final recommendedProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
    if (_productRepository != null) {
      loadProducts();
      loadFeaturedProducts();
      loadRecommendedProducts();
    }
  }

  void _initializeServices() {
    try {
      _productRepository = Get.find<ProductRepository>();
    } catch (e) {
      print('Error initializing product services: $e');
      Future.delayed(Duration(milliseconds: 500), () {
        _initializeServices();
      });
    }
  }

  Future<void> loadProducts({int? categoryId, String? search}) async {
    if (_productRepository == null) return;

    isLoading.value = true;

    try {
      final response = await _productRepository!.getProducts(
        categoryId: categoryId,
        search: search,
      );

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        products.value = productList.map((json) => ProductModel.fromJson(json)).toList();
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
    if (_productRepository == null) return;

    try {
      final response = await _productRepository!.getProducts(featured: true);

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        featuredProducts.value = productList.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  Future<void> loadRecommendedProducts() async {
    if (_productRepository == null) return;

    try {
      final response = await _productRepository!.getProducts(recommended: true);

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        recommendedProducts.value = productList.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading recommended products: $e');
    }
  }

  Future<void> searchProducts(String query) async {
    await loadProducts(search: query);
  }

  Future<void> loadProductsByCategory(int categoryId) async {
    await loadProducts(categoryId: categoryId);
  }
}