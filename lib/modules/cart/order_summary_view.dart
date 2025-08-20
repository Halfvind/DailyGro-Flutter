import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../controllers/address_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/coupon_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../controllers/wallet_controller.dart';
import '../../routes/app_routes.dart';
import '../orders/widgets/coupon_bottom_sheet.dart';
import '../profile/views/address_list_view.dart';

class OrderSummaryView extends StatelessWidget {
  const OrderSummaryView({super.key});

  CartController get cartController => Get.find<CartController>();
  CouponController get couponController => Get.find<CouponController>();
  OrdersController get ordersController => Get.find<OrdersController>();
  AddressController get addressController => Get.find<AddressController>();
  WalletController get walletController => Get.find<WalletController>();

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
                  // Delivery Address Section
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontSize: AppSizes.fontL,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.to(() => AddressListView()),
                              child: Text('Change'),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.height(8)),
                        Obx(() {
                          final defaultAddress = addressController.addresses
                              .firstWhereOrNull((addr) => addr.isDefault);
                          
                          if (defaultAddress == null) {
                            return GestureDetector(
                              onTap: () => Get.to(() => AddressListView()),
                              child: Container(
                                padding: EdgeInsets.all(AppSizes.width(16)),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.add_location, color: Colors.red),
                                    SizedBox(width: AppSizes.width(8)),
                                    Text(
                                      'Add Delivery Address',
                                      style: TextStyle(
                                        fontSize: AppSizes.fontM,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                defaultAddress.fullName,
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSizes.height(4)),
                              Text(
                                '${defaultAddress.addressLine1}${defaultAddress.addressLine2.isNotEmpty ? ', ${defaultAddress.addressLine2}' : ''}',
                                style: TextStyle(
                                  fontSize: AppSizes.fontM,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${defaultAddress.city}, ${defaultAddress.state} - ${defaultAddress.pincode}',
                                style: TextStyle(
                                  fontSize: AppSizes.fontM,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: AppSizes.height(4)),
                              Text(
                                defaultAddress.phone,
                                style: TextStyle(
                                  fontSize: AppSizes.fontM,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSizes.height(16)),
                  
                  // Order Items
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
                                          item.product.name ?? '',
                                          style: TextStyle(
                                            fontSize: AppSizes.fontM,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${item.currentUnit} × ${item.quantity.value}',
                                          style: TextStyle(
                                            fontSize: AppSizes.fontS,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(0)}',
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
                  
                  // Payment Method Selection
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
                        
                        Obx(() {
                          final deliveryFee = cartController.totalAmount >= 299 ? 0 : 49;
                          final discount = couponController.getDiscountAmount(cartController.totalAmount);
                          final finalAmount = cartController.totalAmount + deliveryFee - discount;
                          final canPayWithWallet = walletController.canPayWithWallet(finalAmount);
                          
                          return Column(
                            children: [
                              // Wallet Payment Option
                              Container(
                                padding: EdgeInsets.all(AppSizes.width(12)),
                                decoration: BoxDecoration(
                                  color: canPayWithWallet ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                                  border: Border.all(
                                    color: canPayWithWallet ? Colors.blue : Colors.grey,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: canPayWithWallet ? Colors.blue : Colors.grey,
                                      size: AppSizes.fontXL,
                                    ),
                                    SizedBox(width: AppSizes.width(12)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pay with Wallet',
                                            style: TextStyle(
                                              fontSize: AppSizes.fontM,
                                              fontWeight: FontWeight.w600,
                                              color: canPayWithWallet ? Colors.black : Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'Balance: ₹${walletController.walletBalance.value.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: AppSizes.fontS,
                                              color: canPayWithWallet ? Colors.blue : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!canPayWithWallet)
                                      Text(
                                        'Insufficient Balance',
                                        style: TextStyle(
                                          fontSize: AppSizes.fontS,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.height(8)),
                              
                              // Other Payment Methods
                              Container(
                                padding: EdgeInsets.all(AppSizes.width(12)),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: Colors.grey[600],
                                      size: AppSizes.fontXL,
                                    ),
                                    SizedBox(width: AppSizes.width(12)),
                                    Text(
                                      'Other Payment Methods',
                                      style: TextStyle(
                                        fontSize: AppSizes.fontM,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  
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
                ],
              ),
            ),
          ),
          
          // Bill Summary
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
                      cartController.totalAmount >= 299 ? 'FREE' : '₹49',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.w600,
                        color: cartController.totalAmount >= 299 ? Colors.green : Colors.black,
                      ),
                    )),
                  ],
                ),
                
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
                      final deliveryFee = cartController.totalAmount >= 299 ? 0 : 49;
                      final discount = couponController.getDiscountAmount(cartController.totalAmount);
                      final finalAmount = cartController.totalAmount + deliveryFee - discount;
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
                  child: Obx(() {
                    final hasAddress = addressController.addresses
                        .any((addr) => addr.isDefault);
                    
                    return ElevatedButton(
                      onPressed: hasAddress ? () async {
                        final deliveryFee = cartController.totalAmount >= 299 ? 0.0 : 49.0;
                        final discount = couponController.getDiscountAmount(cartController.totalAmount);
                        final finalAmount = cartController.totalAmount + deliveryFee - discount;
                        
                        try {
                          // Process payment
                          if (walletController.canPayWithWallet(finalAmount)) {
                            walletController.deductMoney(
                              finalAmount,
                              'Order payment',
                              orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                            );
                          }
                          
                          // Get default address
                          final defaultAddress = addressController.addresses.firstWhereOrNull(
                            (addr) => addr.isDefault
                          );
                          
                          if (defaultAddress == null) {
                            throw Exception('No default address found');
                          }
                          
                          // Make a copy of cart items BEFORE clearing
                          final orderedItemsCopy = cartController.cartItems.toList();
                          
                          // Place the order
                          final orderId = await ordersController.placeOrder(
                            items: orderedItemsCopy,
                            totalAmount: finalAmount,
                            deliveryAddress: '${defaultAddress.addressLine1}, ${defaultAddress.city}, ${defaultAddress.state} - ${defaultAddress.pincode}',
                            paymentMethod: 'Wallet',
                          );
                          
                          if (orderId != null) {
                            // Clear cart and coupon
                            cartController.clearCart();
                            couponController.clearSelectedCoupon();
                            
                            // Navigate to success screen using named route
                            Get.offAllNamed(
                              Routes.productDetail,
                              arguments: orderedItemsCopy,
                              parameters: {
                                'orderId': orderId,
                                'amount': finalAmount.toStringAsFixed(2),
                              },
                            );
                          } else {
                            throw Exception('Failed to place order');
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to place order: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasAddress ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                        ),
                      ),
                      child: Text(
                        hasAddress ? 'PLACE ORDER' : 'ADD ADDRESS TO CONTINUE',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}