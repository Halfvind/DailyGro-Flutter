import 'package:dailygro/modules/rider/models/rider_order_model.dart';
import 'package:get/get.dart';
import '../../../controllers/integrated_order_controller.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../data/api/api_client.dart';

import '../models/rider_profile_model.dart';


class RiderController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  
  final Rx<RiderProfileModel?> riderProfile = Rx<RiderProfileModel?>(null);
  final availabilityStatus = 'offline'.obs;
  final isUpdatingStatus = false.obs;
  final _isLoading = false.obs;
  final activeOrders = <RiderOrderModel>[].obs;
  final completedOrders = <RiderOrderModel>[].obs;
  final Rx<RiderOrderModel?> selectedOrder = Rx<RiderOrderModel?>(null);
  final trackingHistory = <Map<String, dynamic>>[].obs;
  
  bool get isOnline => availabilityStatus.value == 'available';
  bool get isLoading => _isLoading.value;

  void fetchRiderOrders() async {
    try {
      _isLoading.value = true;
      final riderId = riderProfile.value?.riderId ?? 0;
      final response = await apiClient.get('rider/view_orders?rider_id=$riderId');
      
      if (response.body['status'] == 'success') {
        if (response.body['active_orders'] != null) {
          activeOrders.value = (response.body['active_orders'] as List)
              .map((order) => RiderOrderModel.fromJson(order))
              .toList();
        }
        if (response.body['completed_orders'] != null) {
          completedOrders.value = (response.body['completed_orders'] as List)
              .map((order) => RiderOrderModel.fromJson(order))
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching rider orders: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void fetchOrderDetails(int orderId) async {
    try {
      _isLoading.value = true;
      final riderId = riderProfile.value?.riderId ?? 0;
      final response = await apiClient.get('rider/view_orders?rider_id=$riderId&order_id=$orderId');
      
      if (response.body['status'] == 'success') {
        if (response.body['order'] != null) {
          selectedOrder.value = RiderOrderModel.fromJson(response.body['order']);
        }

        if (response.body['tracking_history'] != null) {
          trackingHistory.value = List<Map<String, dynamic>>.from(response.body['tracking_history']);
        }
      }
    } catch (e) {
      print('Error fetching order details: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void updateOrderStatus(int orderId, String status, {String? notes, String? location}) async {
    try {
      final riderId = riderProfile.value?.riderId ?? 0;
      final response = await apiClient.post('rider/view_orders', {
        'rider_id': riderId,
        'order_id': orderId,
        'status': status,
        if (notes != null) 'notes': notes,
        if (location != null) 'location': location,
      });
      
      if (response.body['status'] == 'success') {
        Get.snackbar('Success', 'Order status updated successfully');
        fetchRiderOrders();
        if (selectedOrder.value?.orderId == orderId) {
          fetchOrderDetails(orderId);
        }
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to update order status');
      }
    } catch (e) {
      print('Error updating order status: $e');
      Get.snackbar('Error', 'Failed to update order status');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchRiderProfile();
  }
  
  void fetchRiderProfile() async {
    try {
      _isLoading.value = true;
      final globalController = Get.find<GlobalController>();
      final userId = globalController.userId;
      final response = await apiClient.get('rider/get_rider_profile?id=$userId');
      if (response.body["status"] == 'success') {
        riderProfile.value = RiderProfileModel.fromJson(response.body['user_profile']);
        availabilityStatus.value = response.body['user_profile']['availability_status'] ?? 'offline';
      }
    } catch (e) {
      print('Error fetching rider profile: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void updateAvailabilityStatus(String status) async {
    try {
      isUpdatingStatus.value = true;
      final globalController = Get.find<GlobalController>();
      final riderId = riderProfile.value?.riderId ?? globalController.userId;
      print('RIDER ID >>>>$riderId AND STATUS >>>>$status');
      final response = await apiClient.post('rider/rider_status', {
        'rider_id': riderId,
        'availability_status': status,
      });
      if (response.body["status"] == 'success') {
        // Update local state immediately for better UX
        availabilityStatus.value = status;
        if (riderProfile.value != null) {
          riderProfile.value = RiderProfileModel(
            riderId: riderProfile.value!.riderId,
            riderName: riderProfile.value!.riderName,
            riderEmail: riderProfile.value!.riderEmail,
            contactNumber: riderProfile.value!.contactNumber,
            vehicleType: riderProfile.value!.vehicleType,
            vehicleNumber: riderProfile.value!.vehicleNumber,
            licenseNumber: riderProfile.value!.licenseNumber,
            verificationStatus: riderProfile.value!.verificationStatus,
            rating: riderProfile.value!.rating,
            availabilityStatus: status,
            totalDeliveries: riderProfile.value!.totalDeliveries,
            totalOrders: riderProfile.value!.totalOrders,
            totalEarnings: riderProfile.value!.totalEarnings,
            createdAt: riderProfile.value!.createdAt,
            earningsHistory: riderProfile.value!.earningsHistory,
          );
        }
        Get.snackbar('Status Updated', 
            status == 'available' ? 'You are now online' : 'You are now offline');
      }
    } catch (e) {
      print('Error updating availability status: $e');
      Get.snackbar('Error', 'Failed to update status');
    } finally {
      isUpdatingStatus.value = false;
    }
  }



  // Online/Offline Toggle
  void toggleOnlineStatus() {
    final newStatus = availabilityStatus.value == 'available' ? 'offline' : 'available';
    updateAvailabilityStatus(newStatus);
  }

  void acceptOrder(String orderId) {
    try {
      final integratedController = Get.find<IntegratedOrderController>();
      final riderId = riderProfile.value?.riderId.toString() ?? '0';
      if (integratedController.riderAcceptOrder(orderId, riderId)) {
        Get.snackbar('Order Accepted', 'Order accepted successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order');
    }
  }

  void markOrderDelivered(String orderId) {
    try {
      final integratedController = Get.find<IntegratedOrderController>();
      if (integratedController.riderDeliverOrder(orderId)) {
        Get.snackbar('Order Delivered', 'Order delivered successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark order as delivered');
    }
  }
  
  void logout() {
    try {
      final globalController = Get.find<GlobalController>();
      globalController.logout();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}