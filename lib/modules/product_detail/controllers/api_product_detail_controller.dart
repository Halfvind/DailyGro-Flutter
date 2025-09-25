import 'package:get/get.dart';
import '../../../models/product_detail_model.dart';
import '../../products/repositories/products_repository.dart';

class ApiProductDetailController extends GetxController {
  ProductsRepository? _productsRepository;
  
  final isLoading = false.obs;
  final productDetail = Rxn<ProductDetailModel>();
  final quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
    try {

      _productsRepository = Get.find<ProductsRepository>();
    } catch (e) {
      print('Error initializing product detail services: $e');
    }
  }

  Future<void> loadProductDetail(int productId) async {
    if (_productsRepository == null) {
      print('ProductsRepository is null, trying to initialize...');
      try {
        _productsRepository = Get.put(ProductsRepository());
      } catch (e) {
        print('Failed to initialize ProductsRepository: $e');
        return;
      }
    }

    isLoading.value = true;
    print('Loading product detail for ID: $productId');

    try {
      final response = await _productsRepository!.getProductDetail(productId);
      print('Product detail API response: ${response.body}');

      if (response.isOk && response.body['status'] == 'success') {
        productDetail.value = ProductDetailModel.fromJson(response.body);
        print('Product detail loaded successfully: ${productDetail.value?.product?.name}');
      } else {
        print('API error: ${response.body}');
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load product details');
      }
    } catch (e) {
      print('Exception loading product detail: $e');
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}