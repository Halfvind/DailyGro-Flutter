import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../routes/app_routes.dart';
import '../../../themes/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double orderAmount;
  final List<dynamic> orderedItems;

  const OrderSuccessScreen({
    Key? key,
    required this.orderId,
    required this.orderAmount,
    required this.orderedItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed('/bottomBar');
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.width(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSizes.vSpace(40),
                // Success Animation
                Container(
                  height: AppSizes.width(200),
                  width: AppSizes.width(200),
                  child: Lottie.asset(
                    'assets/lottie/success.json',
                    fit: BoxFit.contain,
                  ),
                ),
                
                AppSizes.vSpace(20),
                Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: AppSizes.font(24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                AppSizes.vSpace(12),
                Text(
                  'Your order #$orderId has been placed successfully.',
                  style: TextStyle(
                    fontSize: AppSizes.font(16),
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                AppSizes.vSpace(24),
                // Order Summary Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.width(16)),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: AppSizes.font(18),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      AppSizes.vSpace(12),
                      ...orderedItems.take(3).map((item) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.height(8)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.product.name}', 
                                style: TextStyle(
                                  fontSize: AppSizes.font(14),
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                            Text(
                              '₹${(item.totalPrice).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: AppSizes.font(14),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      
                      if (orderedItems.length > 3) ...[
                        AppSizes.vSpace(8),
                        Text(
                          '+ ${orderedItems.length - 3} more items',
                          style: TextStyle(
                            fontSize: AppSizes.font(14),
                            color: AppColors.secondaryText,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      
                      Divider(height: AppSizes.height(24), thickness: 1),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: AppSizes.font(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Text(
                            '₹$orderAmount',
                            style: TextStyle(
                              fontSize: AppSizes.font(18),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                AppSizes.vSpace(40),
                // Action Buttons
                Column(
                  children: [
                    CommonButton(
                      onPressed: () {
                        Get.offAllNamed('/bottomBar');
                      },
                      text: 'Continue Shopping',
                    /*  width: double.infinity,
                      height: AppSizes.height(50),
                      fontSize: AppSizes.font(16),*/
                    ),
                    AppSizes.vSpace(12),
                    TextButton(
                      onPressed: () {
                        // Navigate to order details
                      //  Get.toNamed('/order-details', arguments: {'orderId': orderId});
                        print("ksadjsndans");
                        Get.toNamed(Routes.bottomBar);
                      },
                      child: Text(
                        'View Order Details',
                        style: TextStyle(
                          fontSize: AppSizes.font(16),
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
