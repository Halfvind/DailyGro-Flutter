import 'package:get/get.dart';
import '../../../models/wallet_model.dart';
import '../../../models/wallet_transaction_model.dart' hide WalletTransactionModel;
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
    } catch (e) {
      print('WalletRepository not found, creating new instance');
      Get.put(WalletRepository());
      _walletRepository = Get.find<WalletRepository>();
    }

    try {
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('GlobalController not found: $e');
    }
  }

  Future<void> loadWallet() async {
    if (_walletRepository == null || _globalController == null) {
      print('Wallet services not initialized');
      return;
    }
    
    int userIdInt = _globalController!.userId.value;
    if (userIdInt == 0) {
      print('User ID is 0, cannot load wallet');
      return;
    }
    
    isLoading.value = true;
    print('Loading wallet for user ID: $userIdInt');

    try {
      final response = await _walletRepository!.getWallet(userIdInt);
      print('Wallet API response: ${response.body}');

      if (response.isOk && response.body != null) {
        if (response.body['status'] == 'success' && response.body['wallet'] != null) {
          wallet.value = WalletModel.fromJson(response.body['wallet']);
          print('Wallet loaded successfully: balance = ${wallet.value?.balance}');
        } else {
          // Create default wallet if none exists
          wallet.value = WalletModel(
            walletId: 1,
            userId: userIdInt,
            balance: 0.0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          print('Created default wallet');
        }
      } else {
        print('Wallet API failed: ${response.body}');
        // Create default wallet on error
        wallet.value = WalletModel(
          walletId: 1,
          userId: userIdInt,
          balance: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error loading wallet: $e');
      // Create default wallet on exception
      wallet.value = WalletModel(
        walletId: 1,
        userId: userIdInt,
        balance: 0.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTransactions() async {
    if (_walletRepository == null || wallet.value == null) {
      print('Cannot load transactions: repository or wallet not available');
      return;
    }

    print('Loading transactions for wallet ID: ${wallet.value!.walletId}');
    
    try {
      final response = await _walletRepository!.getWalletTransactions(wallet.value!.walletId);
      print('Transactions API response: ${response.body}');

      if (response.isOk && response.body != null) {
        if (response.body['status'] == 'success') {
          final List<dynamic> transactionList = response.body['transactions'] ?? [];
          transactions.value = transactionList.map((json) => WalletTransactionModel.fromJson(json)).toList();
          print('Loaded ${transactions.length} transactions');
        } else {
          transactions.value = [];
          print('No transactions found');
        }
      } else {
        transactions.value = [];
        print('Transactions API failed');
      }
    } catch (e) {
      print('Error loading transactions: $e');
      transactions.value = [];
    }
  }

  double get balance => wallet.value?.balance ?? 0.0;
  int get availableCoupons => 3; // Static for now
}