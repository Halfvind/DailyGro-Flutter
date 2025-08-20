import 'package:get/get.dart';
import '../models/rider_models.dart';
import '../data/rider_dummy_data.dart';
import '../../../controllers/integrated_order_controller.dart';
import '../../../CommonComponents/controllers/global_controller.dart';

class RiderController extends GetxController {
  // Profile
  final _profile = RiderDummyData.riderProfile.obs;
  RiderProfile get profile => _profile.value;

  // Online/Offline status
  final _isOnline = true.obs;
  bool get isOnline => _isOnline.value;

  // Orders from integrated system
  List<dynamic> get availableOrders {
    final integratedController = Get.find<IntegratedOrderController>();
    return integratedController.getAvailableRiderOrders()
        .map((order) => {
          'id': order.id,
          'orderNumber': order.orderNumber,
          'customerName': 'Customer',
          'customerPhone': '+1234567890',
          'customerAddress': order.deliveryAddress,
          'vendorName': 'Vendor Store',
          'vendorAddress': 'Vendor Location',
          'items': order.items,
          'totalAmount': order.totalAmount,
          'deliveryFee': 2.99,
          'status': order.status,
          'createdAt': order.orderDate,
        }).toList();
  }
  
  List<dynamic> get myOrders {
    final integratedController = Get.find<IntegratedOrderController>();
    return integratedController.getRiderOrders(profile.id)
        .map((order) => {
          'id': order.id,
          'orderNumber': order.orderNumber,
          'customerName': 'Customer',
          'customerPhone': '+1234567890',
          'customerAddress': order.deliveryAddress,
          'vendorName': 'Vendor Store',
          'vendorAddress': 'Vendor Location',
          'items': order.items,
          'totalAmount': order.totalAmount,
          'deliveryFee': 2.99,
          'status': order.status,
          'createdAt': order.orderDate,
        }).toList();
  }

  // Earnings
  final _earnings = <RiderEarnings>[].obs;
  final _withdrawals = <WithdrawalRequest>[].obs;
  List<RiderEarnings> get earnings => _earnings;
  List<WithdrawalRequest> get withdrawals => _withdrawals;

  // Loading states
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    _earnings.value = List.from(RiderDummyData.earnings);
    _withdrawals.value = List.from(RiderDummyData.withdrawals);
  }

  // Profile Management
  void updateProfile({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? vehicleType,
    String? vehicleNumber,
    String? licenseNumber,
    String? bankAccount,
    String? ifscCode,
  }) {
    _profile.value = RiderProfile(
      id: profile.id,
      name: name ?? profile.name,
      phone: phone ?? profile.phone,
      email: email ?? profile.email,
      address: address ?? profile.address,
      vehicleType: vehicleType ?? profile.vehicleType,
      vehicleNumber: vehicleNumber ?? profile.vehicleNumber,
      licenseNumber: licenseNumber ?? profile.licenseNumber,
      bankAccount: bankAccount ?? profile.bankAccount,
      ifscCode: ifscCode ?? profile.ifscCode,
      profileImage: profile.profileImage,
      idProof: profile.idProof,
      isOnline: profile.isOnline,
      isVerified: profile.isVerified,
    );
    Get.snackbar('Success', 'Profile updated successfully');
  }

  // Online/Offline Toggle
  void toggleOnlineStatus() {
    _isOnline.value = !_isOnline.value;
    _profile.value = RiderProfile(
      id: profile.id,
      name: profile.name,
      phone: profile.phone,
      email: profile.email,
      address: profile.address,
      vehicleType: profile.vehicleType,
      vehicleNumber: profile.vehicleNumber,
      licenseNumber: profile.licenseNumber,
      bankAccount: profile.bankAccount,
      ifscCode: profile.ifscCode,
      profileImage: profile.profileImage,
      idProof: profile.idProof,
      isOnline: _isOnline.value,
      isVerified: profile.isVerified,
    );
    Get.snackbar('Status Updated', 
        _isOnline.value ? 'You are now online' : 'You are now offline');
  }

  // Order Management - integrated
  void acceptOrder(String orderId) {
    final integratedController = Get.find<IntegratedOrderController>();
    if (integratedController.riderAcceptOrder(orderId, profile.id)) {
      Get.snackbar('Order Accepted', 'Order accepted successfully');
    }
  }

  void rejectOrder(String orderId) {
    Get.snackbar('Order Rejected', 'Order rejected');
  }

  void markOrderPicked(String orderId) {
    final integratedController = Get.find<IntegratedOrderController>();
    if (integratedController.riderPickupOrder(orderId)) {
      Get.snackbar('Order Picked', 'Order marked as picked up');
    }
  }

  void markOrderDelivered(String orderId) {
    final integratedController = Get.find<IntegratedOrderController>();
    if (integratedController.riderDeliverOrder(orderId)) {
      // Add earnings
      _earnings.add(RiderEarnings(
        id: 'earn_${DateTime.now().millisecondsSinceEpoch}',
        orderId: orderId,
        amount: 2.99,
        date: DateTime.now(),
        type: 'delivery',
      ));
      Get.snackbar('Order Delivered', 'Order delivered successfully');
    }
  }

  // Earnings
  double get todayEarnings {
    final today = DateTime.now();
    return _earnings
        .where((e) => 
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.day == today.day)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get weeklyEarnings {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _earnings
        .where((e) => e.date.isAfter(weekStart))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get monthlyEarnings {
    final now = DateTime.now();
    return _earnings
        .where((e) => 
            e.date.year == now.year &&
            e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalEarnings {
    return _earnings.fold(0.0, (sum, e) => sum + e.amount);
  }

  // Withdrawals
  void requestWithdrawal(double amount) {
    if (amount > totalEarnings) {
      Get.snackbar('Error', 'Insufficient balance');
      return;
    }

    final withdrawal = WithdrawalRequest(
      id: 'withdraw_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      requestDate: DateTime.now(),
      status: 'pending',
      bankAccount: '****${profile.bankAccount.substring(profile.bankAccount.length - 4)}',
    );

    _withdrawals.insert(0, withdrawal);
    Get.snackbar('Withdrawal Requested', 
        'Withdrawal request of \$${amount.toStringAsFixed(2)} submitted');
  }
  
  @override
  void onClose() {
    // Clean up when controller is disposed
    super.onClose();
  }
  
  void logout() {
    final globalController = Get.find<GlobalController>();
    globalController.logout();
  }
}