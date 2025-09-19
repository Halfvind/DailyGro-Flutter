import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderController extends GetxController {
  OrderRepository? _orderRepository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final orders = <OrderModel>[].obs;
  final orderTracking = Rxn<OrderTrackingModel>();

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
    // Don't auto-load orders - only load when OrdersView is opened
  }

  void _initializeServices() {
    try {
      _orderRepository = Get.find<OrderRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing order services: $e');
    }
  }

  Future<void> loadOrders() async {
    if (_orderRepository == null || _globalController == null) return;

    int userIdInt = _globalController!.userId.value;

    isLoading.value = true;

    try {
      final response = await _orderRepository!.getOrders(userIdInt);

      if (response.isOk) {
        final List<dynamic> orderList = response.body['orders'] ?? [];
        orders.value = orderList.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }



  Future createOrder({
    required double totalAmount,
    required int addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    required  deliveryfee,
    required discountamount,
    required couponcode
  }) async {
    if (_orderRepository == null || _globalController == null) return;

    isLoading.value = true;
    int userIdInt = _globalController!.userId.value;
    try {
      final response = await _orderRepository!.createOrder(
        userId: userIdInt,
        totalAmount: totalAmount,
        addressId: addressId,
        paymentMethod: paymentMethod,
        items: items,
        deliveryfee:deliveryfee,
        discountamount: discountamount,
        couponcode: couponcode,

      );

      if (response.isOk) {
        // Process wallet payment if selected
        if (paymentMethod == 'wallet') {
          final orderId = response.body['order_id'];
          final walletResponse = await _orderRepository!.processWalletPayment(userIdInt, orderId, totalAmount);
          
          if (!walletResponse.isOk || walletResponse.body['status'] != 'success') {
            Get.snackbar('Error', walletResponse.body['message'] ?? 'Wallet payment failed');
            return null;
          }
        }
        
        Get.snackbar('Success', response.body['message'] ?? 'Order created successfully');
        loadOrders();
        return response.body;
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to create order');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOrderTracking(int orderId) async {
    if (_orderRepository == null) return;

    isLoading.value = true;

    try {
      final response = await _orderRepository!.getOrderTracking(orderId);

      if (response.isOk) {
        orderTracking.value = OrderTrackingModel.fromJson(response.body['order_tracking']);
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load order tracking');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}