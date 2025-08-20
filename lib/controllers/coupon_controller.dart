import 'package:get/get.dart';
import '../models/coupon_model.dart';

class CouponController extends GetxController {
  final RxList<CouponModel> availableCoupons = <CouponModel>[].obs;
  final Rxn<CouponModel> selectedCoupon = Rxn<CouponModel>();

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  void loadCoupons() {
    availableCoupons.assignAll([
      CouponModel(
        id: '1',
        code: 'SAVE50',
        title: '₹50 OFF',
        description: 'Get ₹50 off on orders above ₹299',
        discount: 50,
        minOrderAmount: 299,
      ),
      CouponModel(
        id: '2',
        code: 'SAVE100',
        title: '₹100 OFF',
        description: 'Get ₹100 off on orders above ₹499',
        discount: 100,
        minOrderAmount: 499,
      ),
      CouponModel(
        id: '3',
        code: 'SAVE150',
        title: '₹150 OFF',
        description: 'Get ₹150 off on orders above ₹799',
        discount: 150,
        minOrderAmount: 799,
      ),
    ]);
  }

  List<CouponModel> getValidCoupons(double orderAmount) {
    return availableCoupons.where((coupon) => 
        coupon.isActive && orderAmount >= coupon.minOrderAmount).toList();
  }

  void selectCoupon(CouponModel coupon) {
    selectedCoupon.value = coupon;
  }

  void clearSelectedCoupon() {
    selectedCoupon.value = null;
  }

  double getDiscountAmount(double orderAmount) {
    if (selectedCoupon.value != null && orderAmount >= selectedCoupon.value!.minOrderAmount) {
      return selectedCoupon.value!.discount;
    }
    return 0.0;
  }
}