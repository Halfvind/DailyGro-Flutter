import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../repositories/vendor_repository.dart';

class StockManagementController extends GetxController {
  final VendorRepository _repository = Get.find<VendorRepository>();
  final GlobalController _globalController = Get.find<GlobalController>();

  final isLoading = false.obs;
  final products = <Map<String, dynamic>>[].obs;
  final selectedFilter = 'all'.obs;
  final totalProducts = 0.obs;
  final lowStockCount = 0.obs;
  final outOfStockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts({String type = 'all'}) async {
    isLoading.value = true;
    selectedFilter.value = type;
    
    try {
      final response = await _repository.getStockManagement(_globalController.vendorId.value, type);
      
      if (response.isOk) {
        products.value = List<Map<String, dynamic>>.from(response.body['products'] ?? []);
        totalProducts.value = response.body['summary']?['total_products'] ?? 0;
        lowStockCount.value = response.body['summary']?['low_stock_count'] ?? 0;
        outOfStockCount.value = response.body['summary']?['out_of_stock_count'] ?? 0;
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStock(int productId, int newStock) async {
    print('$productId,${_globalController.vendorId.value}, $newStock');
    try {
      final response = await _repository.updateStock(productId, _globalController.vendorId.value, newStock);
      
      if (response.isOk) {
        Get.snackbar('Success', 'Stock updated successfully');
        loadProducts(type: selectedFilter.value);
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to update stock');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    }
  }
}