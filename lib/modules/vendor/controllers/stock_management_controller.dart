import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../repositories/vendor_repository.dart';

class StockManagementController extends GetxController {
  VendorRepository? _repository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final products = <Map<String, dynamic>>[].obs;
  final selectedFilter = 'all'.obs;
  final totalProducts = 0.obs;
  final lowStockCount = 0.obs;
  final outOfStockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProducts();
    });
  }
  
  void _initializeDependencies() {
    try {
      _repository = Get.find<VendorRepository>();
    } catch (e) {
      print('VendorRepository not found: $e');
      _repository = Get.put(VendorRepository());
    }
    
    try {
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('GlobalController not found: $e');
    }
  }

  Future<void> loadProducts({String type = 'all'}) async {
    if (_repository == null || _globalController == null) {
      print('Dependencies not initialized');
      return;
    }
    
    isLoading.value = true;
    selectedFilter.value = type;
    print('Loading products for vendor: ${_globalController!.vendorId.value}, type: $type');
    
    try {
      final response = await _repository!.getStockManagement(_globalController!.vendorId.value, type);
      print('Stock management API response: ${response.body}');
      
      if (response.isOk && response.body != null) {
        if (response.body['status'] == 'success') {
          products.value = List<Map<String, dynamic>>.from(response.body['products'] ?? []);
          totalProducts.value = response.body['summary']?['total_products'] ?? products.length;
          lowStockCount.value = response.body['summary']?['low_stock_count'] ?? 0;
          outOfStockCount.value = response.body['summary']?['out_of_stock_count'] ?? 0;
          print('Loaded ${products.length} products');
        } else {
          print('API returned error: ${response.body['message']}');
          Get.snackbar('Error', response.body['message'] ?? 'Failed to load products');
        }
      } else {
        print('API request failed: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      print('Exception loading products: $e');
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStock(int productId, int newStock) async {
    if (_repository == null || _globalController == null) {
      print('Dependencies not initialized');
      return;
    }
    
    print('Updating stock: productId=$productId, vendorId=${_globalController!.vendorId.value}, newStock=$newStock');
    try {
      final response = await _repository!.updateStock(productId, _globalController!.vendorId.value, newStock);
      print('Update stock response: ${response.body}');
      
      if (response.isOk && response.body != null && response.body['status'] == 'success') {
        Get.snackbar('Success', 'Stock updated successfully');
        loadProducts(type: selectedFilter.value);
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to update stock');
      }
    } catch (e) {
      print('Exception updating stock: $e');
      Get.snackbar('Error', 'Network error occurred');
    }
  }
}