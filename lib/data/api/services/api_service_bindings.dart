import 'package:get/get.dart';
import '../api_client.dart';
import 'user_api_service.dart';
import 'vendor_api_service.dart';
import 'rider_api_service.dart';

class ApiServiceBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.lazyPut<UserApiService>(() => UserApiService());
    Get.lazyPut<VendorApiService>(() => VendorApiService());
    Get.lazyPut<RiderApiService>(() => RiderApiService());
  }
}