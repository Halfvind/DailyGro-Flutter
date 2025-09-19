import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class VendorRepository extends GetxService {
  ApiClient? _apiClient;
  
  @override
  void onInit() {
    super.onInit();
    try {
      _apiClient = Get.find<ApiClient>();
    } catch (e) {
      print('ApiClient not found in VendorRepository: $e');
    }
  }

   getVendorProfile(int vendorId) async {
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.get('vendor/get_vendor_profile?id=$vendorId');
  }

   updateVendorProfile(Map<String, dynamic> profileData) async {
    return _apiClient?.post('vendor/get_vendor_profile', profileData);
  }

  Future<Response> getVendorOrders(int vendorId, String status) async {
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.get('vendor/vendor_orders?type=list_orders&vendor_id=$vendorId&status=$status');
  }

  Future<Response> acceptOrder(int orderId, int vendorId) async {
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.post('vendor/vendor_orders?type=accept_order', {
      'order_id': orderId,
      'vendor_id': vendorId,
    });
  }

  Future<Response> rejectOrder(int orderId, int vendorId, String reason) async {
    if (_apiClient == null) {
      return const Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.post('vendor/vendor_orders?type=reject_order', {
      'order_id': orderId,
      'vendor_id': vendorId,
      'reason': reason,
    });

  }

  Future<Response> markOrderReady(int orderId, int vendorId) async {
    if (_apiClient == null) {
      return const Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.post('vendor/vendor_orders?type=mark_ready', {
      'order_id': orderId,
      'vendor_id': vendorId,
    });
  }

   getWalletTransactions(int vendorId) {
    return _apiClient?.get('vendor/wallet?vendor_id=$vendorId');
  }

   getVendorAnalytics(int vendorId) {
    return _apiClient?.get('vendor/earnings?vendor_id=$vendorId');
  }

  Future<Response> getVendorEarnings(int vendorId, String period) async {
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.get('vendor/earnings?vendor_id=$vendorId&period=$period');
  }

   getCategories() {
    return _apiClient?.get('vendor/categories_selection');
  }

   getUnits() {
    return _apiClient?.get('vendor/units_selection');
  }

  addProduct(Map<String, dynamic> productData) {
    return _apiClient?.post('vendor/add_product', productData);
  }

  Future<Response> getStockManagement(int vendorId, String type) async {
    print('PRINTING THE BODY DATA OF VENDOR STOCK MANAGEMENT $vendorId$type');
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.get('vendor/stock_management?vendor_id=$vendorId&type=$type');
  }

  Future<Response> updateStock(int productId, int vendorId, int stockQuantity) async {
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.post('vendor/update_stock', {
      'product_id': productId,
      'vendor_id': vendorId,
      'stock_quantity': stockQuantity,
    });
  }
  
  Future<Response> assignRider(int orderId) async {
    if (_apiClient == null) {
      return Response(statusCode: 500, body: {'status': 'error', 'message': 'API client not available'});
    }
    return _apiClient!.post('vendor/vendor_orders?type=assign_rider', {
      'order_id': orderId,
    });
  }
}