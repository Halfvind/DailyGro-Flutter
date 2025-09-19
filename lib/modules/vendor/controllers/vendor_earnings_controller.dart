import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../repositories/vendor_repository.dart';

class VendorEarningsController extends GetxController {
  VendorRepository? _repository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final walletBalance = '0.00'.obs;
  final totalEarnings = '0.00'.obs;
  final totalOrders = 0.obs;
  final completedOrders = 0.obs;
  final cancelledOrders = 0.obs;
  final transactions = <Map<String, dynamic>>[].obs;
  final recentOrders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
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

  Future<void> loadEarnings(String period) async {
    if (_repository == null || _globalController == null) {
      print('Services not initialized');
      return;
    }

    isLoading.value = true;
    print('Loading earnings for period: $period, vendorId: ${_globalController!.vendorId.value}');

    try {
      final response = await _repository!.getVendorEarnings(_globalController!.vendorId.value, period);
      print('Earnings API response: ${response.body}');

      if (response.isOk && response.body != null && response.body['status'] == 'success') {
        _parseEarningsResponse(response.body);
      } else {
        print('Earnings API failed: ${response.body}');
        _setDefaultValues();
      }
    } catch (e) {
      print('Error loading earnings: $e');
      _setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  void _parseEarningsResponse(Map<String, dynamic> data) {
    // Parse wallet balance
    walletBalance.value = _formatBalance(data['balance'] ?? data['wallet_balance'] ?? '0.00');
    
    // Parse summary data
    if (data['summary'] != null) {
      final summary = data['summary'];
      totalOrders.value = int.tryParse(summary['total_orders']?.toString() ?? '0') ?? 0;
      completedOrders.value = int.tryParse(summary['completed_orders']?.toString() ?? '0') ?? 0;
      cancelledOrders.value = int.tryParse(summary['cancelled_orders']?.toString() ?? '0') ?? 0;
      totalEarnings.value = _formatBalance(summary['total_earnings'] ?? '0.00');
    } else {
      // If no summary, calculate from transactions
      totalEarnings.value = _calculateTotalFromTransactions(data['transactions'] ?? []);
    }
    
    // Parse transactions
    if (data['transactions'] != null && data['transactions'] is List) {
      transactions.value = List<Map<String, dynamic>>.from(data['transactions']);
    } else {
      transactions.value = [];
    }
    
    // Parse recent orders
    if (data['recent_orders'] != null && data['recent_orders'] is List) {
      recentOrders.value = List<Map<String, dynamic>>.from(data['recent_orders']);
    } else {
      recentOrders.value = [];
    }

    print('Parsed data - Balance: ${walletBalance.value}, Earnings: ${totalEarnings.value}, Orders: ${totalOrders.value}');
  }

  String _formatBalance(dynamic balance) {
    if (balance == null) return '0.00';
    String balanceStr = balance.toString().replaceAll(',', '');
    double amount = double.tryParse(balanceStr) ?? 0.0;
    return amount.toStringAsFixed(2);
  }

  String _calculateTotalFromTransactions(List transactions) {
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction['type'] == 'credit') {
        double amount = double.tryParse(transaction['amount']?.toString() ?? '0') ?? 0.0;
        total += amount;
      }
    }
    return total.toStringAsFixed(2);
  }

  void _setDefaultValues() {
    walletBalance.value = '0.00';
    totalEarnings.value = '0.00';
    totalOrders.value = 0;
    completedOrders.value = 0;
    cancelledOrders.value = 0;
    transactions.value = [];
    recentOrders.value = [];
  }
}