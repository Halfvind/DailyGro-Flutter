import 'package:get/get.dart';
import '../../../data/repositories/vendor_repository.dart';
import '../models/vendor_model.dart';
import '../models/product_model.dart';
import '../../../controllers/integrated_order_controller.dart';

class VendorController extends GetxController {
  final VendorRepository _repository = Get.find<VendorRepository>();
  
  final _vendor = Rxn<VendorModel>();
  final _products = <ProductModel>[].obs;
  final _transactions = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _walletBalance = 2450.75.obs;
  
  // Orders from integrated system
  List<dynamic> get orders {
    if (_vendor.value == null) return [];
    final integratedController = Get.find<IntegratedOrderController>();
    return integratedController.getVendorOrders(_vendor.value!.id)
        .map((order) => {
          'id': order.id,
          'orderNumber': order.orderNumber,
          'customerName': 'Customer',
          'items': order.items,
          'totalAmount': order.totalAmount,
          'status': order.status,
          'orderDate': order.orderDate,
        }).toList();
  }
  
  VendorModel? get vendor => _vendor.value;
  List<ProductModel> get products => _products;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoading => _isLoading.value;
  double get walletBalance => _walletBalance.value;
  
  @override
  void onInit() {
    super.onInit();
    loadDashboard();
    loadProducts();
    loadDummyTransactions();
  }
  
  Future<void> loadDashboard() async {
    _isLoading.value = true;
    try {
      final data = await _repository.getDashboardData();
      if (data != null) {
        _vendor.value = VendorModel.fromJson(data['vendor']);
      } else {
        // Load dummy data for new vendors
        _vendor.value = VendorModel(
          id: '1',
          name: 'Fresh Mart Store',
          email: 'vendor@dailygro.com',
          phone: '+1 234 567 8900',
          businessName: 'Fresh Mart Store',
          address: '123 Market Street, City',
          isActive: true,
          rating: 4.8,
          totalOrders: 245,
          totalEarnings: 2450.75,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> loadProducts() async {
    try {
      final data = await _repository.getProducts();
      if (data != null) {
        _products.value = data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        // Load dummy products for new vendors
        _products.value = [
          ProductModel(
            id: '1',
            name: 'Fresh Apples',
            description: 'Crispy red apples',
            price: 3.99,
            category: 'Fruits',
            imageUrl: '',
            stock: 50,
            isActive: true,
            createdAt: DateTime.now(),
          ),
          ProductModel(
            id: '2',
            name: 'Organic Milk',
            description: 'Fresh organic milk',
            price: 4.50,
            category: 'Dairy',
            imageUrl: '',
            stock: 25,
            isActive: true,
            createdAt: DateTime.now(),
          ),
        ];
      }
    } catch (e) {
      // Handle error
    }
  }
  
  Future<bool> addProduct(ProductModel product) async {
    try {
      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: product.name,
        description: product.description,
        price: product.price,
        category: product.category,
        imageUrl: product.imageUrl,
        stock: product.stock,
        isActive: true,
        createdAt: DateTime.now(),
      );
      _products.add(newProduct);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updateProduct(String productId, ProductModel updatedProduct) async {
    try {
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = updatedProduct;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> deleteProduct(String productId) async {
    try {
      _products.removeWhere((p) => p.id == productId);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updateStock(String productId, int newStock) async {
    try {
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = _products[index];
        _products[index] = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          category: product.category,
          imageUrl: product.imageUrl,
          stock: newStock,
          isActive: product.isActive,
          createdAt: product.createdAt,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updateVendorProfile(VendorModel updatedVendor) async {
    try {
      _vendor.value = updatedVendor;
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> withdrawAmount(double amount) async {
    try {
      if (amount <= _walletBalance.value) {
        _walletBalance.value -= amount;
        
        final transaction = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': 'Withdrawal',
          'amount': -amount,
          'date': DateTime.now().toString(),
          'status': 'Pending',
          'description': 'Withdrawal request',
        };
        
        _transactions.insert(0, transaction);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Order Management
  void acceptOrder(String orderId) {
    if (_vendor.value == null) return;
    final integratedController = Get.find<IntegratedOrderController>();
    integratedController.vendorAcceptOrder(orderId, _vendor.value!.id);
  }

  void rejectOrder(String orderId) {
    if (_vendor.value == null) return;
    final integratedController = Get.find<IntegratedOrderController>();
    integratedController.vendorRejectOrder(orderId, _vendor.value!.id);
  }
  
  void loadDummyTransactions() {
    _transactions.addAll([
      {
        'id': '1',
        'type': 'Order Payment',
        'amount': 85.50,
        'date': DateTime.now().subtract(const Duration(hours: 2)).toString(),
        'status': 'Completed',
        'description': 'Order #1001 payment',
      },
      {
        'id': '2',
        'type': 'Commission',
        'amount': -12.40,
        'date': DateTime.now().subtract(const Duration(days: 1)).toString(),
        'status': 'Completed',
        'description': 'Platform commission',
      },
    ]);
  }
}