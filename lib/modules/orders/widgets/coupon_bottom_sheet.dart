import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../coupon/controllers/coupon_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class CouponBottomSheet extends StatefulWidget {
  const CouponBottomSheet({super.key});

  @override
  State<CouponBottomSheet> createState() => _CouponBottomSheetState();
}

class _CouponBottomSheetState extends State<CouponBottomSheet> {
  late final CouponController couponController;
  late final CartController cartController;

  @override
  void initState() {
    super.initState();
    couponController = Get.put(CouponController());
    cartController = Get.find<CartController>();

    // Call API to load coupons
    couponController.loadCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radius(20))),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSizes.width(16)),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Coupons',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Coupons List
          Expanded(
            child: Obx(() {
              if (couponController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (couponController.coupons.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No coupons available'),
                    ],
                  ),
                );
              }

              final orderAmount = cartController.totalAmount.value;

              final eligibleCoupons = couponController.coupons
                  .where((c) => couponController.isCouponEligible(c, orderAmount))
                  .toList();

              final ineligibleCoupons = couponController.coupons
                  .where((c) => !couponController.isCouponEligible(c, orderAmount))
                  .toList();

              return ListView(
                padding: EdgeInsets.all(AppSizes.width(16)),
                children: [
                  if (eligibleCoupons.isNotEmpty) ...[
                    Text(
                      'Eligible Coupons',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: AppSizes.height(12)),
                    ...eligibleCoupons.map((c) => _buildCouponCard(c, true, orderAmount)),
                  ],
                  if (ineligibleCoupons.isNotEmpty) ...[
                    if (eligibleCoupons.isNotEmpty) SizedBox(height: AppSizes.height(20)),
                    Text(
                      'Other Coupons',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: AppSizes.height(12)),
                    ...ineligibleCoupons.map((c) => _buildCouponCard(c, false, orderAmount)),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(coupon, bool isEligible, double orderAmount) {
    final validUntil = DateTime.tryParse(coupon.validUntil) ?? DateTime.now();
    final isExpired = validUntil.isBefore(DateTime.now());
    final minOrderNotMet = orderAmount < coupon.minOrderAmount;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(12)),
      decoration: BoxDecoration(
        color: isEligible ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        border: Border.all(
          color: isEligible ? Colors.green[200]! : Colors.grey[300]!,
          width: isEligible ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: isEligible ? () => couponController.selectCoupon(coupon) : null,
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.width(8)),
                    decoration: BoxDecoration(
                      color: isEligible ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                    ),
                    child: Icon(Icons.local_offer,
                        color: isEligible ? Colors.green : Colors.grey,
                        size: AppSizes.font(20)),
                  ),
                  SizedBox(width: AppSizes.width(12)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(12),
                        vertical: AppSizes.height(6),
                      ),
                      decoration: BoxDecoration(
                        color: isEligible ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(AppSizes.radius(6)),
                      ),
                      child: Text(
                        coupon.code,
                        style: TextStyle(
                          fontSize: AppSizes.fontM,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (isEligible)
                    Icon(Icons.arrow_forward_ios,
                        size: AppSizes.font(16), color: Colors.green),
                ],
              ),
              SizedBox(height: AppSizes.height(12)),
              Text(
                coupon.title,
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                  color: isEligible ? Colors.black : Colors.grey[600],
                ),
              ),
              SizedBox(height: AppSizes.height(4)),
              Text(
                coupon.description,
                style: TextStyle(fontSize: AppSizes.fontM, color: Colors.grey[600]),
              ),
              SizedBox(height: AppSizes.height(8)),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width(8),
                      vertical: AppSizes.height(4),
                    ),
                    decoration: BoxDecoration(
                      color: isEligible ? Colors.green[50] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppSizes.radius(4)),
                    ),
                    child: Text(
                      coupon.discountType == 'percentage'
                          ? '${coupon.discountValue.toInt()}% OFF'
                          : '₹${coupon.discountValue.toInt()} OFF',
                      style: TextStyle(
                        fontSize: AppSizes.fontS,
                        fontWeight: FontWeight.bold,
                        color: isEligible ? Colors.green[700] : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (isEligible && orderAmount >= coupon.minOrderAmount) ...[
                    SizedBox(width: AppSizes.width(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(8),
                        vertical: AppSizes.height(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(AppSizes.radius(4)),
                      ),
                      child: Text(
                        'Save ₹${coupon.getDiscountAmount(orderAmount).toInt()}',
                        style: TextStyle(
                          fontSize: AppSizes.fontS,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: AppSizes.height(8)),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Min order: ₹${coupon.minOrderAmount.toInt()}',
                      style: TextStyle(
                        fontSize: AppSizes.fontS,
                        color: minOrderNotMet ? Colors.red : Colors.grey[600],
                        fontWeight: minOrderNotMet ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    'Valid till ${DateFormat('dd MMM').format(validUntil)}',
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      color: isExpired ? Colors.red : Colors.grey[600],
                      fontWeight: isExpired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (!isEligible) ...[
                SizedBox(height: AppSizes.height(8)),
                Container(
                  padding: EdgeInsets.all(AppSizes.width(8)),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(AppSizes.radius(6)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: AppSizes.font(16), color: Colors.red),
                      SizedBox(width: AppSizes.width(6)),
                      Expanded(
                        child: Text(
                          isExpired
                              ? 'This coupon has expired'
                              : 'Add ₹${(coupon.minOrderAmount - orderAmount).toInt()} more to use this coupon',
                          style: TextStyle(
                              fontSize: AppSizes.fontS,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
