import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../repositories/vendor_repository.dart';

class AddProductController extends GetxController {
  final VendorRepository _vendorRepository = Get.find<VendorRepository>();
  final GlobalController _globalController = Get.find<GlobalController>();

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final originalPriceController = TextEditingController();
  final stockController = TextEditingController();
  final weightController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final categories = <Map<String, dynamic>>[].obs;
  final units = <Map<String, dynamic>>[].obs;
  final selectedCategoryId = Rxn<int>();
  final selectedUnit = Rxn<String>();
  final isFeatured = false.obs;
  final isRecommended = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await Future.wait([
      loadCategories(),
      loadUnits(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadCategories() async {
    try {
      final response = await _vendorRepository.getCategories();
      if (response.isOk) {
        categories.value = List<Map<String, dynamic>>.from(response.body['categories'] ?? []);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    }
  }

  Future<void> loadUnits() async {
    try {
      final response = await _vendorRepository.getUnits();
      if (response.isOk) {
        units.value = List<Map<String, dynamic>>.from(response.body['units'] ?? []);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load units');
    }
  }

  Future<void> addProduct() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    
    final productData = {
      'vendor_id': _globalController.vendorId,
      'category_id': selectedCategoryId.value,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': double.parse(priceController.text),
      'original_price': double.parse(originalPriceController.text),
      'stock_quantity': int.parse(stockController.text),
      'unit': selectedUnit.value,
      'weight': weightController.text.trim(),
      'is_featured': isFeatured.value ? 1 : 0,
      'is_recommended': isRecommended.value ? 1 : 0,
    };

    try {
      final response = await _vendorRepository.addProduct(productData);
      
      if (response.isOk) {
        Get.snackbar('Success', 'Product added successfully');
        _clearForm();
        Get.back();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to add product');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Product name is required');
      return false;
    }
    if (selectedCategoryId.value == null) {
      Get.snackbar('Error', 'Please select a category');
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Price is required');
      return false;
    }
    if (originalPriceController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Original price is required');
      return false;
    }
    if (selectedUnit.value == null) {
      Get.snackbar('Error', 'Please select a unit');
      return false;
    }
    if (stockController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Stock quantity is required');
      return false;
    }
    return true;
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    originalPriceController.clear();
    stockController.clear();
    weightController.clear();
    selectedCategoryId.value = null;
    selectedUnit.value = null;
    isFeatured.value = false;
    isRecommended.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    originalPriceController.dispose();
    stockController.dispose();
    weightController.dispose();
    super.onClose();
  }
}