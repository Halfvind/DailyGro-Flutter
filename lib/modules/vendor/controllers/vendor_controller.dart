import 'package:get/get.dart';
import '../repositories/vendor_repository.dart';
import '../models/vendor_model.dart';
import '../models/product_model.dart';
import '../../../CommonComponents/controllers/global_controller.dart';

class VendorController extends GetxController {
  VendorRepository? _repository;
  GlobalController? _globalController;
  
  final _vendor = Rxn<VendorModel>();
  final _products = <ProductModel>[].obs;
  final _transactions = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _walletBalance = 2450.75.obs;
  final _orders = <Map<String, dynamic>>[].obs;
  final _businessLicense = ''.obs;
  final _businessType = 'Retail'.obs;
  final _storeStatus = 'open'.obs;
  final _openingTime = '09:00:00'.obs;
  final _closingTime = '21:00:00'.obs;
  final _upiId = ''.obs;
  final _bankAccount = ''.obs;
  final _analytics = <String, dynamic>{}.obs;

  VendorModel? get vendor => _vendor.value;
  String get businessLicense => _businessLicense.value;
  String get businessType => _businessType.value;
  String get storeStatus => _storeStatus.value;
  String get openingTime => _openingTime.value;
  String get closingTime => _closingTime.value;
  String get upiId => _upiId.value;
  String get bankAccount => _bankAccount.value;
  List<ProductModel> get products => _products;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading.value;
  double get walletBalance => _walletBalance.value;
  Map<String, dynamic> get analytics => _analytics;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadDashboard();
    loadProducts();
    loadWalletTransactions();
  }

  void _initializeDependencies() {
    try {
      _repository = Get.find<VendorRepository>();
    } catch (e) {
      print('VendorRepository not found: $e');
    }
    
    try {
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('GlobalController not found: $e');
    }
  }

  void updateStoreStatus(bool isOpen) {
    _storeStatus.value = isOpen ? 'open' : 'closed';
  }

  void updateBusinessType(String type) {
    _businessType.value = type;
  }

  void updateOperatingHours(String opening, String closing) {
    _openingTime.value = opening;
    _closingTime.value = closing;
  }

  Future<void> loadVendorProfile() async {
    if (_repository == null || _globalController == null) return;
    
    _isLoading.value = true;
    try {
      final response = await _repository!.getVendorProfile(_globalController!.userId.value);
      
      if (response.isOk && response.body != null) {
        if (response.body['status'] == 'success' && response.body['user_profile'] != null) {
          final data = response.body['user_profile'];
          _vendor.value = VendorModel(
            id: (_globalController!.vendorId.value).toString(),
            name: data['vendor_name']?.toString() ?? 'Vendor',
            email: data['vendor_mail']?.toString() ?? '',
            phone: data['contact_number']?.toString() ?? '',
            businessName: data['store_name']?.toString() ?? 'Business',
            address: data['business_address']?.toString() ?? '',
            isActive: data['verification_status'] == 'verified',
            rating: double.tryParse(data['rating']?.toString() ?? '0') ?? 0.0,
            totalOrders: 0,
            totalEarnings: 0.0,
          );
          _businessLicense.value = data['business_license']?.toString() ?? '';
          _businessType.value = data['business_type']?.toString() ?? 'Retail';
          _storeStatus.value = data['store_status']?.toString() ?? 'open';
          _openingTime.value = data['opening_time']?.toString() ?? '09:00:00';
          _closingTime.value = data['closing_time']?.toString() ?? '21:00:00';
          _upiId.value = data['upi_id']?.toString() ?? '';
          _bankAccount.value = data['bank_account_number']?.toString() ?? '';
        }
      }
    } catch (e) {
      print('Error loading vendor profile: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadVendorOrders(String status) async {
    if (_repository == null || _globalController == null) return;
    
    _isLoading.value = true;
    print('Loading vendor orders for status: $status, vendorId: ${_globalController!.vendorId.value}');
    
    try {
      final response = await _repository!.getVendorOrders(_globalController!.vendorId.value, status);
      print('Vendor orders API response: ${response.body}');
      
      if (response.isOk && response.body != null && response.body['status'] == 'success') {
        final ordersData = response.body['orders'];
        if (ordersData != null && ordersData is List) {
          _orders.value = List<Map<String, dynamic>>.from(ordersData);
          print('Loaded ${_orders.length} orders');
        } else {
          _orders.value = [];
          print('No orders data found');
        }
      } else {
        _orders.value = [];
        print('Orders API failed: ${response.body}');
      }
    } catch (e) {
      print('Error loading vendor orders: $e');
      _orders.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> acceptOrder(int orderId) async {
    if (_repository == null || _globalController == null) return false;
    
    try {
      final response = await _repository!.acceptOrder(orderId, _globalController!.vendorId.value);
      if (response.isOk && response.body['status'] == 'success') {
        Get.snackbar('Success', 'Order accepted successfully');
        return true;
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to accept order');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: $e');
      return false;
    }
  }

  Future<bool> rejectOrder(int orderId, String reason) async {
    if (_repository == null || _globalController == null) return false;
    
    try {
      final response = await _repository!.rejectOrder(orderId, _globalController!.vendorId.value, reason);
      if (response.isOk && response.body['status'] == 'success') {
        Get.snackbar('Success', 'Order rejected successfully');
        return true;
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to reject order');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject order: $e');
      return false;
    }
  }

  Future<bool> markOrderReady(int orderId) async {
    if (_repository == null || _globalController == null) return false;
    
    try {
      final response = await _repository!.markOrderReady(orderId, _globalController!.vendorId.value);
      if (response.isOk && response.body['status'] == 'success') {
        // After marking ready, assign rider
        await _assignRider(orderId);
        Get.snackbar('Success', 'Order marked as ready and rider assigned');
        return true;
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to mark order as ready');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark order as ready: $e');
      return false;
    }
  }
  
  Future<void> _assignRider(int orderId) async {
    if (_repository == null) return;
    
    try {
      final response = await _repository!.assignRider(orderId);
      if (response.isOk && response.body['status'] == 'success') {
        print('Rider assigned successfully for order $orderId');
      } else {
        print('Failed to assign rider: ${response.body['message']}');
      }
    } catch (e) {
      print('Error assigning rider: $e');
    }
  }

  Future<void> loadDashboard() async {
    await loadVendorProfile();
  }

  Future<void> loadProducts() async {
    if (_repository == null || _globalController == null) return;
    
    try {
      final response = await _repository!.getStockManagement(_globalController!.vendorId.value, 'list_products');
      
      if (response.isOk && response.body != null && response.body['status'] == 'success') {
        final productsData = response.body['data'];
        if (productsData != null && productsData is List) {
          _products.value = productsData.map((item) => ProductModel(
            id: item['product_id']?.toString() ?? '0',
            name: item['product_name']?.toString() ?? 'Product',
            description: item['description']?.toString() ?? '',
            price: double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
            category: item['category_name']?.toString() ?? 'Category',
            imageUrl: item['image_url']?.toString() ?? '',
            stock: int.tryParse(item['stock_quantity']?.toString() ?? '0') ?? 0,
            isActive: item['is_active'] == 1 || item['is_active'] == '1',
            createdAt: DateTime.tryParse(item['created_at']?.toString() ?? '') ?? DateTime.now(),
          )).toList();
        } else {
          _products.value = [];
        }
      } else {
        _products.value = [];
      }
    } catch (e) {
      print('Error loading products: $e');
      _products.value = [];
    }
  }

  Future<bool> updateVendorProfile(Map<String, dynamic> profileData) async {
    if (_repository == null) return false;
    
    try {
      final response = await _repository!.updateVendorProfile(profileData);
      if (response.isOk && response.body['status'] == 'success') {
        await loadVendorProfile();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating vendor profile: $e');
      return false;
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

  Future<void> loadWalletTransactions() async {
    if (_repository == null || _globalController == null) return;
    
    try {
      final response = await _repository!.getWalletTransactions(_globalController!.vendorId.value);
      if (response.isOk && response.body != null && response.body['status'] == 'success') {
        final transactionsData = response.body['data'];
        if (transactionsData != null && transactionsData is List) {
          _transactions.value = List<Map<String, dynamic>>.from(transactionsData);
        } else {
          _transactions.value = [];
        }
        _walletBalance.value = double.tryParse(response.body['wallet_balance']?.toString() ?? '0') ?? 0.0;
      } else {
        _transactions.value = [];
      }
    } catch (e) {
      print('Error loading wallet transactions: $e');
      _transactions.value = [];
    }
  }

  Future<void> loadAnalytics() async {
    if (_repository == null || _globalController == null) return;
    
    try {
      final response = await _repository!.getVendorAnalytics(_globalController!.vendorId.value);
      if (response.isOk && response.body['status'] == 'success') {
        _analytics.value = response.body['data'] ?? {};
      }
    } catch (e) {
      print('Error loading analytics: $e');
    }
  }
}