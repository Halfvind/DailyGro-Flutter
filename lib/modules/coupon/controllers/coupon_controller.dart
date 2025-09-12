import 'package:get/get.dart';
import '../../../models/coupon_model.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../repositories/coupon_repository.dart';

class CouponController extends GetxController {
  CouponRepository? _couponRepository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final coupons = <CouponModel>[].obs;
  final selectedCoupon = Rxn<CouponModel>();

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
    try {
      _couponRepository = Get.find<CouponRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing coupon services: $e');
    }
  }

  Future<void> loadCoupons() async {
    if (_couponRepository == null || _globalController == null) return;

    isLoading.value = true;
    int userIdInt = _globalController!.userId.value;
    try {
      final response = await _couponRepository!.getCoupons(userIdInt);

      if (response.isOk && response.body['status'] == 'success') {
        final List<dynamic> couponList = response.body['coupons'] ?? [];
        coupons.value = couponList
            .map((json) => CouponModel.fromJson(json))
            .where((coupon) => coupon.status == 'active')
            .toList();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load coupons');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
      print('Coupon loading error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCoupon(CouponModel coupon) {
    selectedCoupon.value = coupon;
    Get.back();
  }

  void clearSelectedCoupon() {
    selectedCoupon.value = null;
  }

  double getDiscountAmount(double orderAmount) {
    return selectedCoupon.value?.getDiscountAmount(orderAmount) ?? 0;
  }

 /* bool isCouponEligible(CouponModel coupon, double orderAmount) {
    return orderAmount >= coupon.minOrderAmount && 
           coupon.validUntil.isAfter(DateTime.now()) &&
           coupon.status == 'active';
  }*/

 /* List<CouponModel> getEligibleCoupons(double orderAmount) {
    return coupons.where((coupon) => isCouponEligible(coupon, orderAmount)).toList();
  }*/
}