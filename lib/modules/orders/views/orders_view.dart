import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../controllers/orders_controller.dart';
import '../../../controllers/integrated_order_controller.dart';
import '../../../routes/app_routes.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final integratedController = Get.find<IntegratedOrderController>();
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Orders'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final userOrders = integratedController.getUserOrders('user_001');
        final regularOrders = controller.orders;
        
        if (userOrders.isEmpty && regularOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: AppSizes.font(80),
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSizes.height(16)),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: AppSizes.height(8)),
                Text(
                  'Your order history will appear here',
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
          padding: EdgeInsets.all(AppSizes.width(16)),
          itemCount: userOrders.length + regularOrders.length,
          itemBuilder: (context, index) {
            dynamic order;
            bool isIntegratedOrder = index < userOrders.length;
            
            if (isIntegratedOrder) {
              order = userOrders[index];
            } else {
              order = regularOrders[index - userOrders.length];
            }
            
            return Container(
              margin: EdgeInsets.only(bottom: AppSizes.height(16)),
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
              child: InkWell(
                onTap: () {
                  final orderId = isIntegratedOrder ? order.id : order.id;
                  if (orderId != null) {
                    Get.toNamed(
                      Routes.orderTracking,
                      parameters: {'orderId': orderId.toString()},
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${isIntegratedOrder ? order.orderNumber : order.id.substring(order.id.length - 6)}',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.width(8),
                            vertical: AppSizes.height(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radius(4)),
                          ),
                          child: Text(
                            isIntegratedOrder ? order.status : order.status,
                            style: TextStyle(
                              fontSize: AppSizes.fontS,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppSizes.height(8)),
                    
                    // Date and Time
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(
                        isIntegratedOrder ? order.orderDate : order.orderDate
                      ),
                      style: TextStyle(
                        fontSize: AppSizes.fontS,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    SizedBox(height: AppSizes.height(12)),
                    
                    // Order Items
                    ...(isIntegratedOrder ? order.items : order.items).map((item) => Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.height(8)),
                      child: Row(
                        children: [
                          Container(
                            width: AppSizes.width(40),
                            height: AppSizes.height(40),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(AppSizes.radius(6)),
                            ),
                            child: Icon(
                              Icons.image,
                              size: AppSizes.fontXL,
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
                    )).toList(),
                    
                    Divider(),
                    
                    // Order Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items (${(isIntegratedOrder ? order.items : order.items).fold(0, (sum, item) => sum + item.quantity.value)})',
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${(isIntegratedOrder ? order.totalAmount : order.totalAmount).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppSizes.height(8)),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Paid',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${(isIntegratedOrder ? order.totalAmount : order.totalAmount).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}