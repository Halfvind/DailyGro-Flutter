import 'package:get/get.dart';
import '../models/wallet_transaction_model.dart';

class WalletController extends GetxController {
  final RxDouble walletBalance = 500.0.obs;
  final RxList<WalletTransaction> transactions = <WalletTransaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyTransactions();
  }

  void loadDummyTransactions() {
    transactions.assignAll([
      WalletTransaction(
        id: '1',
        type: 'credit',
        amount: 500.0,
        description: 'Wallet loaded',
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      WalletTransaction(
        id: '2',
        type: 'debit',
        amount: 150.0,
        description: 'Order payment',
        date: DateTime.now().subtract(Duration(days: 1)),
        orderId: 'ORD123',
      ),
    ]);
  }

  void addMoney(double amount) {
    walletBalance.value += amount;
    transactions.insert(0, WalletTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'credit',
      amount: amount,
      description: 'Wallet loaded',
      date: DateTime.now(),
    ));
  }

  bool deductMoney(double amount, String description, {String? orderId}) {
    if (walletBalance.value >= amount) {
      walletBalance.value -= amount;
      transactions.insert(0, WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'debit',
        amount: amount,
        description: description,
        date: DateTime.now(),
        orderId: orderId,
      ));
      return true;
    }
    return false;
  }

  bool canPayWithWallet(double amount) {
    return walletBalance.value >= amount;
  }
}