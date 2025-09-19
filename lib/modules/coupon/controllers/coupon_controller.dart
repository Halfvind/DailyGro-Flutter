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
    } catch (e) {
      print('CouponRepository not found, creating new instance');
      _couponRepository = Get.put(CouponRepository());
    }
    
    try {
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('GlobalController not found: $e');
    }
  }

  Future<void> loadCoupons() async {
    // Re-initialize services if needed
    if (_couponRepository == null || _globalController == null) {
      _initializeServices();
    }
    
    if (_couponRepository == null || _globalController == null) {
      print('CouponController: Services not available');
      return;
    }

    isLoading.value = true;
    int userIdInt = _globalController!.userId.value;
    print('Loading coupons for user ID: $userIdInt');
    
    try {
      final response = await _couponRepository!.getCoupons(userIdInt);
      print('Coupon API response: ${response.body}');

      if (response.isOk && response.body['status'] == 'success') {
        final List<dynamic> couponList = response.body['coupons'] ?? [];
        coupons.value = couponList
            .map((json) => CouponModel.fromJson(json))
            .where((coupon) => coupon.status == 'active')
            .toList();
        print('Loaded ${coupons.length} active coupons');
      } else {
        print('Coupon API failed: ${response.body}');
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

  bool isCouponEligible(CouponModel coupon, double orderAmount) {
    final validUntil = DateTime.tryParse(coupon.validUntil); // convert String to DateTime
    if (validUntil == null) return false; // invalid date
    return coupon.status == 'active' &&
        validUntil.isAfter(DateTime.now()) &&
        orderAmount >= coupon.minOrderAmount;
  }



/* List<CouponModel> getEligibleCoupons(double orderAmount) {
    return coupons.where((coupon) => isCouponEligible(coupon, orderAmount)).toList();
  }*/
}