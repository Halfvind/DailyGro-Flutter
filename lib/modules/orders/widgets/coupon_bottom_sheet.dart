import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../controllers/coupon_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class CouponBottomSheet extends StatelessWidget {
  const CouponBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = Get.find<CouponController>();
    final cartController = Get.find<CartController>();

    return Container(
      padding: EdgeInsets.all(AppSizes.width(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radius(20)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apply Coupon',
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
          
          SizedBox(height: AppSizes.height(16)),
          
        /*  Obx(() {
            final validCoupons = couponController.getValidCoupons(cartController.totalAmount);
            
            if (validCoupons.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: AppSizes.font(60),
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: AppSizes.height(16)),
                    Text(
                      'No coupons available',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Order above ₹299 to unlock coupons',
                      style: TextStyle(
                        fontSize: AppSizes.fontM,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              itemCount: validCoupons.length,
              itemBuilder: (context, index) {
                final coupon = validCoupons[index];
                final isSelected = couponController.selectedCoupon.value?.id == coupon.id;
                
                return Container(
                  margin: EdgeInsets.only(bottom: AppSizes.height(12)),
                  padding: EdgeInsets.all(AppSizes.width(16)),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.withValues(alpha: 0.1) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSizes.width(8)),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                        ),
                        child: Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: AppSizes.fontXL,
                        ),
                      ),
                      
                      SizedBox(width: AppSizes.width(12)),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.title,
                              style: TextStyle(
                                fontSize: AppSizes.fontL,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              coupon.description,
                              style: TextStyle(
                                fontSize: AppSizes.fontS,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Code: ${coupon.code}',
                              style: TextStyle(
                                fontSize: AppSizes.fontS,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            couponController.clearSelectedCoupon();
                          } else {
                            couponController.selectCoupon(coupon);
                          }
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.width(16),
                            vertical: AppSizes.height(8),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(AppSizes.radius(6)),
                          ),
                          child: Text(
                            isSelected ? 'REMOVE' : 'APPLY',
                            style: TextStyle(
                              fontSize: AppSizes.fontS,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),*/
        ],
      ),
    );
  }
}