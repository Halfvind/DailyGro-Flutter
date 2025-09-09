import 'package:get/get.dart';
import '../../../models/category_model.dart';
import '../repositories/category_repository.dart';

class CategoryController extends GetxController {
  CategoryRepository? _categoryRepository;

  final isLoading = false.obs;
  final categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
    if (_categoryRepository != null) {
      loadCategories();
    }
  }

  void _initializeServices() {
    try {
      _categoryRepository = Get.find<CategoryRepository>();
    } catch (e) {
      print('Error initializing category services: $e');
      Future.delayed(Duration(milliseconds: 500), () {
        _initializeServices();
      });
    }
  }

  Future<void> loadCategories() async {
    if (_categoryRepository == null) {
      print('Category repository not initialized yet');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _categoryRepository!.getCategories();

      if (response.isOk) {
        final List<dynamic> categoryList = response.body['categories'] ?? [];
        categories.value = categoryList.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}