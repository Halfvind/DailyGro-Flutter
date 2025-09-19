import 'package:get/get.dart';
import '../../../models/api_product_model.dart';
import '../repositories/products_repository.dart';
import '../../../data/api/api_client.dart';

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
      // Try to create it if not found
      try {
        Get.put(ProductsRepository());
        _productsRepository = Get.find<ProductsRepository>();
      } catch (e2) {
        print('Failed to create ProductsRepository: $e2');
      }
    }
  }

  Future<void> loadProducts({int? categoryId}) async {
    if (_productsRepository == null) return;

    isLoading.value = true;

    try {
      final response = await _productsRepository!.getProducts(categoryId: categoryId);

      print('Category products API response: ${response.body}');
      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        print('Category products count: ${productList.length}');
        products.value = productList.map((json) {
          try {
            return ApiProductModel.fromJson(json);
          } catch (e) {
            print('Error parsing category product JSON: $e');
            print('Problematic JSON: $json');
            rethrow;
          }
        }).toList();
      } else {
        print('Category products API error: ${response.body}');
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
      print('Featured products API response: ${response.body}');

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        print('Featured products count: ${productList.length}');
        products.value = productList.map((json) {
          try {
            return ApiProductModel.fromJson(json);
          } catch (e) {
            print('Error parsing featured product JSON: $e');
            print('Problematic JSON: $json');
            rethrow;
          }
        }).toList();
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
      print('Recommended products API response: ${response.body}');

      if (response.isOk) {
        final List<dynamic> productList = response.body['products'] ?? [];
        print('Recommended products count: ${productList.length}');
        products.value = productList.map((json) {
          try {
            return ApiProductModel.fromJson(json);
          } catch (e) {
            print('Error parsing recommended product JSON: $e');
            print('Problematic JSON: $json');
            rethrow;
          }
        }).toList();
      }
    } catch (e) {
      print('Error loading recommended products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}