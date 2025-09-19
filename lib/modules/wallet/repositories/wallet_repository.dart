import 'package:get/get.dart';
import '../../../data/api/api_client.dart';

class WalletRepository extends GetxService {
  ApiClient? _apiClient;
  
  @override
  void onInit() {
    super.onInit();
    try {
      _apiClient = Get.find<ApiClient>();
    } catch (e) {
      print('ApiClient not found in WalletRepository: $e');
    }
  }

  Future<Response> getWallet(int userId) async {
    if (_apiClient == null) {
      return Response(
        statusCode: 500,
        body: {'status': 'error', 'message': 'API client not available'},
      );
    }
    return _apiClient!.get('users/wallet?user_id=$userId');
  }

  Future<Response> getWalletTransactions(int walletId) async {
    if (_apiClient == null) {
      return Response(
        statusCode: 500,
        body: {'status': 'error', 'message': 'API client not available'},
      );
    }
    return _apiClient!.get('users/wallet_transactions?wallet_id=$walletId');
  }
}