import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../cart/controllers/cart_controller.dart';
import '../coupon/controllers/coupon_controller.dart';
import '../orders/widgets/coupon_bottom_sheet.dart';
import 'order_summary_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CouponController get couponController => Get.find<CouponController>();
  CartController get controller => Get.find<CartController>();

  @override
  void initState() {
    super.initState();
  //  controller = Get.find<CartController>();
    controller.loadCart();
  }

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
                          child: cartItem.image != null
                              ? Image.network(
                            'http://localhost/dailygro/uploads/${cartItem.image}',
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
                                cartItem.name,
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSizes.height(4)),

                              Text(
                                '${cartItem.weight} ${cartItem.unit}',
                                style: TextStyle(
                                  fontSize: AppSizes.fontS,
                                  color: Colors.grey[600],
                                ),
                              ),

                              SizedBox(height: AppSizes.height(8)),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${cartItem.price}',
                                    style: TextStyle(
                                      fontSize: AppSizes.fontL,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(AppSizes.radius(6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (cartItem.quantity > 1) {
                                              controller.updateCartItem(cartItem.cartId, cartItem.quantity - 1);
                                            } else {
                                              controller.removeFromCart(cartItem.cartId);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(AppSizes.width(6)),
                                            child: Icon(
                                              Icons.remove,
                                              size: AppSizes.fontL,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSizes.width(12),
                                            vertical: AppSizes.height(4),
                                          ),
                                          child: Text(
                                            cartItem.quantity.toString(),
                                            style: TextStyle(
                                              fontSize: AppSizes.fontM,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.updateCartItem(cartItem.cartId, cartItem.quantity + 1);
                                          },
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
                      Text(
                        controller.itemCount.toString(),
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

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
                      Text(
                        '₹${controller.totalAmount}',
                        style: TextStyle(
                          fontSize: AppSizes.fontL,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
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
                        'PROCEED TO CHECKOUT',
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


