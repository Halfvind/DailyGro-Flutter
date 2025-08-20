import 'package:get/get.dart';
import '../models/cart_item_model.dart';

class IntegratedOrder {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final double totalAmount;
  final String status; // placed, vendor_accepted, vendor_rejected, rider_assigned, picked_up, delivered, cancelled
  final List<CartItem> items;
  final String deliveryAddress;
  final String paymentMethod;
  final String userId;
  final String? vendorId;
  final String? riderId;
  final DateTime? vendorAcceptedAt;
  final DateTime? riderAssignedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;

  IntegratedOrder({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.userId,
    this.vendorId,
    this.riderId,
    this.vendorAcceptedAt,
    this.riderAssignedAt,
    this.pickedUpAt,
    this.deliveredAt,
  });

  IntegratedOrder copyWith({
    String? status,
    String? vendorId,
    String? riderId,
    DateTime? vendorAcceptedAt,
    DateTime? riderAssignedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
  }) {
    return IntegratedOrder(
      id: id,
      orderNumber: orderNumber,
      orderDate: orderDate,
      totalAmount: totalAmount,
      status: status ?? this.status,
      items: items,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      userId: userId,
      vendorId: vendorId ?? this.vendorId,
      riderId: riderId ?? this.riderId,
      vendorAcceptedAt: vendorAcceptedAt ?? this.vendorAcceptedAt,
      riderAssignedAt: riderAssignedAt ?? this.riderAssignedAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}

class IntegratedOrderController extends GetxController {
  static IntegratedOrderController get instance => Get.find();
  
  final RxList<IntegratedOrder> _allOrders = <IntegratedOrder>[].obs;
  
  // Get orders for specific user
  List<IntegratedOrder> getUserOrders(String userId) {
    return _allOrders.where((order) => order.userId == userId).toList();
  }
  
  // Get orders for specific vendor
  List<IntegratedOrder> getVendorOrders(String vendorId) {
    return _allOrders.where((order) => 
      order.vendorId == vendorId || order.items.isNotEmpty
    ).toList();
  }
  
  // Get available orders for riders
  List<IntegratedOrder> getAvailableRiderOrders() {
    return _allOrders.where((order) => 
      order.status == 'vendor_accepted' && order.riderId == null
    ).toList();
  }
  
  // Get orders for specific rider
  List<IntegratedOrder> getRiderOrders(String riderId) {
    return _allOrders.where((order) => order.riderId == riderId).toList();
  }
  
  // Place new order (User action)
  String placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String paymentMethod,
    required String userId,
  }) {
    final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    
    final order = IntegratedOrder(
      id: orderId,
      orderNumber: orderNumber,
      orderDate: DateTime.now(),
      totalAmount: totalAmount,
      status: 'placed',
      items: items,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      userId: userId,
    );
    
    _allOrders.add(order);
    Get.snackbar('Success', 'Order placed successfully');
    return orderId;
  }
  
  // Vendor accepts order
  bool vendorAcceptOrder(String orderId, String vendorId) {
    final index = _allOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _allOrders[index] = _allOrders[index].copyWith(
        status: 'vendor_accepted',
        vendorId: vendorId,
        vendorAcceptedAt: DateTime.now(),
      );
      Get.snackbar('Success', 'Order accepted');
      return true;
    }
    return false;
  }
  
  // Vendor rejects order
  bool vendorRejectOrder(String orderId, String vendorId) {
    final index = _allOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _allOrders[index] = _allOrders[index].copyWith(
        status: 'vendor_rejected',
        vendorId: vendorId,
      );
      Get.snackbar('Info', 'Order rejected');
      return true;
    }
    return false;
  }
  
  // Rider accepts order
  bool riderAcceptOrder(String orderId, String riderId) {
    final index = _allOrders.indexWhere((order) => order.id == orderId);
    if (index != -1 && _allOrders[index].status == 'vendor_accepted') {
      _allOrders[index] = _allOrders[index].copyWith(
        status: 'rider_assigned',
        riderId: riderId,
        riderAssignedAt: DateTime.now(),
      );
      Get.snackbar('Success', 'Order accepted for delivery');
      return true;
    }
    return false;
  }
  
  // Rider picks up order
  bool riderPickupOrder(String orderId) {
    final index = _allOrders.indexWhere((order) => order.id == orderId);
    if (index != -1 && _allOrders[index].status == 'rider_assigned') {
      _allOrders[index] = _allOrders[index].copyWith(
        status: 'picked_up',
        pickedUpAt: DateTime.now(),
      );
      Get.snackbar('Success', 'Order picked up');
      return true;
    }
    return false;
  }
  
  // Rider delivers order
  bool riderDeliverOrder(String orderId) {
    final index = _allOrders.indexWhere((order) => order.id == orderId);
    if (index != -1 && _allOrders[index].status == 'picked_up') {
      _allOrders[index] = _allOrders[index].copyWith(
        status: 'delivered',
        deliveredAt: DateTime.now(),
      );
      Get.snackbar('Success', 'Order delivered successfully');
      return true;
    }
    return false;
  }
  
  // User cancels order (only if not accepted by vendor)
  bool userCancelOrder(String orderId) {
    final index = _allOrders.indexWhere((order) => order.id == orderId);
    if (index != -1 && _allOrders[index].status == 'placed') {
      _allOrders[index] = _allOrders[index].copyWith(status: 'cancelled');
      Get.snackbar('Info', 'Order cancelled');
      return true;
    }
    return false;
  }
  
  // Get order by ID
  IntegratedOrder? getOrderById(String orderId) {
    try {
      return _allOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}