import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../cart/controllers/cart_controller.dart';
import '../order/controllers/order_controller.dart';

class OrderSummaryView extends StatelessWidget {
  const OrderSummaryView({super.key});

  CartController get cartController => Get.find<CartController>();
  OrderController get orderController => Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.width(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section (Static for now)
                  Container(
                    padding: EdgeInsets.all(AppSizes.width(16)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(8)),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          '123 Main Street, Apartment 4B',
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'New York, NY - 10001',
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          '+1 234 567 8900',
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSizes.height(16)),
                  
                  // Order Items from API
                  Container(
                    padding: EdgeInsets.all(AppSizes.width(16)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Items',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(12)),
                        Obx(() => Column(
                          children: cartController.cartItems.map((item) => 
                            Padding(
                              padding: EdgeInsets.only(bottom: AppSizes.height(12)),
                              child: Row(
                                children: [
                                  Container(
                                    width: AppSizes.width(50),
                                    height: AppSizes.height(50),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                                    ),
                                    child: item.image != null
                                        ? Image.network(
                                            'http://localhost/dailygro/uploads/${item.image}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.image,
                                                size: AppSizes.fontXXXL,
                                                color: Colors.grey[400],
                                              );
                                            },
                                          )
                                        : Icon(
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
                                          item.name,
                                          style: TextStyle(
                                            fontSize: AppSizes.fontM,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${item.weight} ${item.unit} × ${item.quantity}',
                                          style: TextStyle(
                                            fontSize: AppSizes.fontS,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.itemTotal.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: AppSizes.fontM,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).toList(),
                        )),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSizes.height(16)),
                  
                  // Payment Method Selection (Static for now)
                  Container(
                    padding: EdgeInsets.all(AppSizes.width(16)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(12)),
                        
                        Container(
                          padding: EdgeInsets.all(AppSizes.width(12)),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.money,
                                color: Colors.green,
                                size: AppSizes.fontXL,
                              ),
                              SizedBox(width: AppSizes.width(12)),
                              Text(
                                'Cash on Delivery',
                                style: TextStyle(
                                  fontSize: AppSizes.fontM,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Commented out coupon section
                  /*
                  SizedBox(height: AppSizes.height(16)),
                  
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
                            child: Text(
                              'Apply Coupon',
                              style: TextStyle(
                                fontSize: AppSizes.fontM,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
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
                  */
                ],
              ),
            ),
          ),
          
          // Bill Summary from API
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items Total:',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(() => Text(
                      '₹${cartController.totalAmount.toStringAsFixed(0)}',
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
                      cartController.totalAmount.value >= 299 ? 'FREE' : '₹49',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.w600,
                        color: cartController.totalAmount.value >= 299 ? Colors.green : Colors.black,
                      ),
                    )),
                  ],
                ),
                
                // Commented out discount section
                /*
                // Discount Row
                Obx(() {
                  final discount = couponController.getDiscountAmount(cartController.totalAmount);
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
                */
                
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
                      final deliveryFee = cartController.totalAmount.value >= 299 ? 0 : 49;
                      final finalAmount = cartController.totalAmount.value + deliveryFee;
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
                
                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final deliveryFee = cartController.totalAmount.value >= 299 ? 0.0 : 49.0;
                      final finalAmount = cartController.totalAmount.value + deliveryFee;
                      
                      try {
                        // Prepare order items for API
                        final orderItems = cartController.cartItems.map((item) => {
                          'product_id': item.productId,
                          'quantity': item.quantity,
                          'price': item.price,
                        }).toList();
                        
                        // Create order via API
                        final result = await orderController.createOrder(
                          totalAmount: finalAmount,
                          addressId: 1, // Static address ID for now
                          paymentMethod: 'cash',
                          items: orderItems,
                        );
                        
                        if (result != null) {
                          // Clear cart
                          cartController.clearCart();
                          
                          // Show success message
                          Get.snackbar(
                            'Success',
                            'Order placed successfully!',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          
                          // Navigate back to home
                          Get.offAllNamed('/home');
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to place order: ${e.toString()}',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                      ),
                    ),
                    child: Text(
                      'PLACE ORDER',
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
      ),
    );
  }
}