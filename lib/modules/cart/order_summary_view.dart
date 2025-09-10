import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../address/controllers/address_controller.dart';
import '../cart/controllers/cart_controller.dart';
import '../order/controllers/order_controller.dart';
import '../coupon/controllers/coupon_controller.dart';
import '../orders/widgets/coupon_bottom_sheet.dart';
import '../profile/views/address_list_view.dart';

class OrderSummaryView extends StatelessWidget {
  OrderSummaryView({super.key});

  CartController get cartController => Get.find<CartController>();
  OrderController get orderController => Get.find<OrderController>();
  final addressController = Get.put(AddressController());
  final couponController = Get.put(CouponController());
  final selectedPaymentMethod = 'cash'.obs;

  @override
  Widget build(BuildContext context) {
    // Load addresses when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressController.loadAddresses();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
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
                  // Delivery Address Section with API
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
                                defaultAddress.name,
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSizes.height(4)),
                              Text(
                                '${defaultAddress.addressLine}${defaultAddress.landmark!.isNotEmpty ? ', ${defaultAddress.landmark}' : ''}',
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
                  
                  // Payment Method Section
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
                        Obx(() => Column(
                          children: [
                            _buildPaymentOption('cash', 'Cash on Delivery', Icons.money),
                            _buildPaymentOption('wallet', 'Wallet Payment', Icons.account_balance_wallet),
                            _buildPaymentOption('online', 'Online Payment', Icons.payment),
                          ],
                        )),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSizes.height(16)),
                  
                  // Apply Coupon Section with API
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        const CouponBottomSheet(),
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
          
          // Bill Summary with coupon discount
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
                
                // Discount Row with API
                Obx(() {
                  final discount = couponController.getDiscountAmount(cartController.totalAmount.value);
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
                      final deliveryFee = cartController.totalAmount.value >= 299 ? 0 : 49;
                      final discount = couponController.getDiscountAmount(cartController.totalAmount.value);
                      final finalAmount = cartController.totalAmount.value + deliveryFee - discount;
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
                        final deliveryFee = cartController.totalAmount.value >= 299 ? 0.0 : 49.0;
                        final discount = couponController.getDiscountAmount(cartController.totalAmount.value);
                        final finalAmount = cartController.totalAmount.value + deliveryFee - discount;
                        
                        try {
                          final orderItems = cartController.cartItems.map((item) => {
                            'product_id': item.productId,
                            'quantity': item.quantity,
                            'price': item.price,
                          }).toList();
                          
                          final result = await orderController.createOrder(
                            totalAmount: finalAmount,
                            addressId: addressController.addresses.firstWhere((addr) => addr.isDefault).addressId,
                            paymentMethod: selectedPaymentMethod.value,
                            items: orderItems,
                          );
                          
                          if (result != null) {
                            cartController.clearCart();
                            couponController.clearSelectedCoupon();
                            
                            Get.snackbar(
                              'Success',
                              'Order placed successfully!',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            
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
  
  Widget _buildPaymentOption(String value, String title, IconData icon) {
    return GestureDetector(
      onTap: () => selectedPaymentMethod.value = value,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.height(8)),
        padding: EdgeInsets.all(AppSizes.width(12)),
        decoration: BoxDecoration(
          color: selectedPaymentMethod.value == value ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          border: Border.all(
            color: selectedPaymentMethod.value == value ? Colors.green : Colors.grey.withValues(alpha: 0.3),
            width: selectedPaymentMethod.value == value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selectedPaymentMethod.value == value ? Colors.green : Colors.grey[600],
              size: AppSizes.fontXL,
            ),
            SizedBox(width: AppSizes.width(12)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppSizes.fontM,
                  fontWeight: selectedPaymentMethod.value == value ? FontWeight.w600 : FontWeight.normal,
                  color: selectedPaymentMethod.value == value ? Colors.green : Colors.grey[700],
                ),
              ),
            ),
            if (selectedPaymentMethod.value == value)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: AppSizes.fontL,
              ),
          ],
        ),
      ),
    );
  }
}