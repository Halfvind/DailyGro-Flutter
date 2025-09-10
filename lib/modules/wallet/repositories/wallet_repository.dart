import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class WalletRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getWallet(int userId) {
    return _apiClient.get('users/wallet?user_id=$userId');
  }

  Future<Response> getWalletTransactions(int walletId) {
    return _apiClient.get('users/wallet_transactions?wallet_id=$walletId');
  }
}