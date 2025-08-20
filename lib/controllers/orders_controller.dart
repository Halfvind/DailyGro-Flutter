import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item_model.dart';

class OrderItem {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final List<CartItem> items;
  final String deliveryAddress;
  final String paymentMethod;

  OrderItem({
    String? id,
    required this.orderNumber,
    required this.totalAmount,
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = 'Processing',
    DateTime? orderDate,
  })  : id = id ?? const Uuid().v4(),
        orderDate = orderDate ?? DateTime.now();
}

class OrdersController extends GetxController {
  final RxList<OrderItem> orders = <OrderItem>[].obs;
  final RxBool isLoading = false.obs;

  // Place a new order
  Future<String?> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate order number (e.g., ORD-123456)
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      
      // Create new order
      final newOrder = OrderItem(
        orderNumber: orderNumber,
        totalAmount: totalAmount,
        items: List<CartItem>.from(items), // Create a copy of items
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        status: 'Confirmed',
      );
      
      // Add to orders list
      orders.insert(0, newOrder);
      
      // Update order count in local storage
      // await _saveOrdersToStorage();
      
      return newOrder.id;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Get order by ID
  OrderItem? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get all orders (sorted by date, newest first)
  List<OrderItem> getAllOrders() {
    return orders.toList()..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  // Get orders by status
  List<OrderItem> getOrdersByStatus(String status) {
    return orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        final order = orders[index];
        orders[index] = OrderItem(
          id: order.id,
          orderNumber: order.orderNumber,
          orderDate: order.orderDate,
          totalAmount: order.totalAmount,
          status: newStatus,
          items: order.items,
          deliveryAddress: order.deliveryAddress,
          paymentMethod: order.paymentMethod,
        );
        // await _saveOrdersToStorage();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Load orders from storage (for persistence)
  // Future<void> _loadOrdersFromStorage() async {
  //   // Implement local storage loading logic here
  //   // For example, using GetStorage, SharedPreferences, etc.
  // }

  // Save orders to storage
  // Future<void> _saveOrdersToStorage() async {
  //   // Implement local storage saving logic here
  // }
}