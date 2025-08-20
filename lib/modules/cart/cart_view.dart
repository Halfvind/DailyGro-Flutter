import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/coupon_controller.dart';
import '../orders/widgets/coupon_bottom_sheet.dart';
import 'order_summary_view.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  CouponController get couponController => Get.find<CouponController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (!controller.hasItems) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: AppSizes.font(80),
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSizes.height(16)),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: AppSizes.height(8)),
                Text(
                  'Add items to get started',
                  style: TextStyle(
                    fontSize: AppSizes.fontM,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppSizes.width(16)),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = controller.cartItems[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: AppSizes.height(12)),
                    padding: EdgeInsets.all(AppSizes.width(12)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: AppSizes.width(60),
                          height: AppSizes.height(60),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                          ),
                          child: Icon(
                            Icons.image,
                            size: AppSizes.fontXXXL,
                            color: Colors.grey[400],
                          ),
                        ),
                        
                        SizedBox(width: AppSizes.width(12)),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.product.name ?? '',
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSizes.height(4)),
                              
                              SizedBox(
                                height: AppSizes.height(32),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cartItem.product.variants.length,
                                  itemBuilder: (context, variantIndex) {
                                    return Obx(() {
                                      final isSelected = cartItem.selectedVariantIndex.value == variantIndex;
                                      return GestureDetector(
                                        onTap: () => controller.updateItemVariant(index, variantIndex),
                                        child: Container(
                                          margin: EdgeInsets.only(right: AppSizes.width(8)),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSizes.width(8),
                                            vertical: AppSizes.height(4),
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.green : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                                            border: Border.all(
                                              color: isSelected ? Colors.green : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              cartItem.product.variants[variantIndex].unit,
                                              style: TextStyle(
                                                fontSize: AppSizes.fontXS,
                                                color: isSelected ? Colors.white : Colors.grey[700],
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.height(4)),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => Text(
                                    '₹${cartItem.totalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: AppSizes.fontL,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  )),
                                  
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(AppSizes.radius(6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () => controller.updateItemQuantity(index, cartItem.quantity.value - 1),
                                          child: Container(
                                            padding: EdgeInsets.all(AppSizes.width(6)),
                                            child: Icon(
                                              Icons.remove,
                                              size: AppSizes.fontL,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Obx(() => Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSizes.width(12),
                                            vertical: AppSizes.height(4),
                                          ),
                                          child: Text(
                                            cartItem.quantity.value.toString(),
                                            style: TextStyle(
                                              fontSize: AppSizes.fontM,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )),
                                        GestureDetector(
                                          onTap: () => controller.updateItemQuantity(index, cartItem.quantity.value + 1),
                                          child: Container(
                                            padding: EdgeInsets.all(AppSizes.width(6)),
                                            child: Icon(
                                              Icons.add,
                                              size: AppSizes.fontL,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            Container(
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Apply Coupon Section
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        CouponBottomSheet(),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.width(12)),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_offer,
                            color: Colors.green,
                            size: AppSizes.fontXL,
                          ),
                          SizedBox(width: AppSizes.width(8)),
                          Expanded(
                            child: Obx(() => Text(
                              couponController.selectedCoupon.value != null
                                  ? 'Coupon Applied: ${couponController.selectedCoupon.value!.code}'
                                  : 'Apply Coupon',
                              style: TextStyle(
                                fontSize: AppSizes.fontM,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            )),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                            size: AppSizes.fontL,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: AppSizes.height(16)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Items:',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Obx(() => Text(
                        controller.totalItems.toString(),
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.height(8)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Obx(() => Text(
                        '₹${controller.totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.height(8)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Fee:',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Obx(() => Text(
                        controller.totalAmount >= 299 ? 'FREE' : '₹49',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w600,
                          color: controller.totalAmount >= 299 ? Colors.green : Colors.black,
                        ),
                      )),
                    ],
                  ),
                  
                  // Discount Row
                  Obx(() {
                    final discount = couponController.getDiscountAmount(controller.totalAmount);
                    if (discount > 0) {
                      return Column(
                        children: [
                          SizedBox(height: AppSizes.height(8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount:',
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '-₹${discount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),
                  
                  SizedBox(height: AppSizes.height(8)),
                  Divider(),
                  SizedBox(height: AppSizes.height(8)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        final deliveryFee = controller.totalAmount >= 299 ? 0 : 49;
                        final discount = couponController.getDiscountAmount(controller.totalAmount);
                        final finalAmount = controller.totalAmount + deliveryFee - discount;
                        return Text(
                          '₹${finalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        );
                      }),
                    ],
                  ),
                  
                  SizedBox(height: AppSizes.height(16)),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => OrderSummaryView()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                        ),
                      ),
                      child: Text(
                        'ORDER SUMMARY',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
