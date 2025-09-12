import 'package:get/get.dart';
import '../../../models/wallet_model.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../repositories/wallet_repository.dart';

class WalletController extends GetxController {
  WalletRepository? _walletRepository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final wallet = Rxn<WalletModel>();
  final transactions = <WalletTransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
    try {
      _walletRepository = Get.find<WalletRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing wallet services: $e');
    }
  }

  Future<void> loadWallet() async {
    if (_walletRepository == null || _globalController == null) return;
    int userIdInt = _globalController!.userId.value;
    isLoading.value = true;

    try {
      final response = await _walletRepository!.getWallet(userIdInt);

      if (response.isOk) {
        wallet.value = WalletModel.fromJson(response.body['wallet']);
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load wallet');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTransactions() async {
    if (_walletRepository == null || wallet.value == null) return;

    try {
      final response = await _walletRepository!.getWalletTransactions(wallet.value!.walletId);

      if (response.isOk) {
        final List<dynamic> transactionList = response.body['transactions'] ?? [];
        transactions.value = transactionList.map((json) => WalletTransactionModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  double get balance => wallet.value?.balance ?? 0.0;
  int get availableCoupons => 3; // Static for now
}