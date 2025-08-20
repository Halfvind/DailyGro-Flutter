import 'package:get/get.dart';
import '../api/api_client.dart';

class RiderRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  Future<Map<String, dynamic>?> getRiderProfile(String riderId) async {
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'success': true,
      'data': {
        'id': riderId,
        'name': 'John Rider',
        'phone': '+1234567890',
        'email': 'rider@dailygro.com',
        'isOnline': true,
        'isVerified': true,
      }
    };
  }
  
  Future<List<Map<String, dynamic>>> getAvailableOrders() async {
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': 'order_001',
        'customerName': 'Alice Johnson',
        'customerAddress': '456 Customer Ave',
        'vendorName': 'Fresh Mart',
        'totalAmount': 25.99,
        'deliveryFee': 2.99,
        'status': 'pending',
      }
    ];
  }
  
  Future<bool> acceptOrder(String orderId) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
  
  Future<bool> updateOrderStatus(String orderId, String status) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
  
  Future<bool> requestWithdrawal(double amount) async {
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}