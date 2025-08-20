import 'package:get/get.dart';

class NotificationService extends GetxService {
  
  Future<NotificationService> init() async {
    // Initialize notification service
    return this;
  }
  
  void showOrderNotification(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 3),
    );
  }
  
  void showDeliveryNotification(String orderId, String status) {
    Get.snackbar(
      'Delivery Update',
      'Order #$orderId is now $status',
      duration: const Duration(seconds: 3),
    );
  }
  
  void showVendorNotification(String message) {
    Get.snackbar(
      'Vendor Alert',
      message,
      duration: const Duration(seconds: 3),
    );
  }
}