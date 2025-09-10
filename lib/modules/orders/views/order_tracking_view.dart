import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../order/controllers/order_controller.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final orderId = Get.arguments as int;
    
    // Load order tracking data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.loadOrderTracking(orderId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final tracking = orderController.orderTracking.value;
        if (tracking == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Unable to load tracking information'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              _buildOrderHeader(tracking),
              
              SizedBox(height: AppSizes.height(24)),
              
              // Current Status
              _buildCurrentStatus(tracking),
              
              SizedBox(height: AppSizes.height(24)),
              
              // Status Steps
              _buildStatusSteps(tracking.statusSteps),
              
              SizedBox(height: AppSizes.height(24)),
              
              // Delivery Address
              _buildDeliveryAddress(tracking.deliveryAddress),
              
              if (tracking.riderInfo != null) ...[
                SizedBox(height: AppSizes.height(24)),
                _buildRiderInfo(tracking.riderInfo!),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderHeader(tracking) {
    return Container(
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
                'Order #${tracking.orderNumber}',
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
                  color: _getStatusColor(tracking.currentStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radius(4)),
                ),
                child: Text(
                  tracking.currentStatus.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppSizes.fontS,
                    color: _getStatusColor(tracking.currentStatus),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(8)),
          Text(
            'Placed on ${DateFormat('MMM dd, yyyy • hh:mm a').format(tracking.createdAt)}',
            style: TextStyle(
              fontSize: AppSizes.fontS,
              color: Colors.grey[600],
            ),
          ),
          if (tracking.estimatedDelivery != null) ...[
            SizedBox(height: AppSizes.height(4)),
            Text(
              'Estimated delivery: ${DateFormat('MMM dd, yyyy').format(tracking.estimatedDelivery!)}',
              style: TextStyle(
                fontSize: AppSizes.fontS,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentStatus(tracking) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(tracking.currentStatus).withValues(alpha: 0.1),
            _getStatusColor(tracking.currentStatus).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        border: Border.all(
          color: _getStatusColor(tracking.currentStatus).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.width(12)),
            decoration: BoxDecoration(
              color: _getStatusColor(tracking.currentStatus),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(tracking.currentStatus),
              color: Colors.white,
              size: AppSizes.font(24),
            ),
          ),
          SizedBox(width: AppSizes.width(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tracking.currentStatusInfo?.title ?? tracking.currentStatus,
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(tracking.currentStatus),
                  ),
                ),
                SizedBox(height: AppSizes.height(4)),
                Text(
                  tracking.currentStatusInfo?.description ?? '',
                  style: TextStyle(
                    fontSize: AppSizes.fontM,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSteps(List<dynamic> statusSteps) {
    return Container(
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
            'Order Progress',
            style: TextStyle(
              fontSize: AppSizes.fontL,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.height(16)),
          ...statusSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == statusSteps.length - 1;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: AppSizes.width(24),
                      height: AppSizes.height(24),
                      decoration: BoxDecoration(
                        color: step.completed 
                            ? Colors.green 
                            : step.active 
                                ? Colors.orange 
                                : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.completed 
                            ? Icons.check 
                            : step.active 
                                ? Icons.radio_button_checked 
                                : Icons.radio_button_unchecked,
                        color: Colors.white,
                        size: AppSizes.font(16),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: AppSizes.height(40),
                        color: step.completed ? Colors.green : Colors.grey[300],
                      ),
                  ],
                ),
                SizedBox(width: AppSizes.width(16)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.height(isLast ? 0 : 16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            fontWeight: FontWeight.w600,
                            color: step.completed || step.active 
                                ? Colors.black 
                                : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          step.description,
                          style: TextStyle(
                            fontSize: AppSizes.fontS,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress(deliveryAddress) {
    return Container(
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
            children: [
              Icon(Icons.location_on, color: Colors.green, size: AppSizes.font(20)),
              SizedBox(width: AppSizes.width(8)),
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(12)),
          Text(
            deliveryAddress.name,
            style: TextStyle(
              fontSize: AppSizes.fontM,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.height(4)),
          Text(
            deliveryAddress.phone,
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: AppSizes.height(4)),
          Text(
            deliveryAddress.address,
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderInfo(riderInfo) {
    return Container(
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
            children: [
              Icon(Icons.delivery_dining, color: Colors.blue, size: AppSizes.font(20)),
              SizedBox(width: AppSizes.width(8)),
              Text(
                'Delivery Partner',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(12)),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: AppSizes.width(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      riderInfo.name,
                      style: TextStyle(
                        fontSize: AppSizes.fontM,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      riderInfo.phone,
                      style: TextStyle(
                        fontSize: AppSizes.fontS,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Vehicle: ${riderInfo.vehicleNumber}',
                      style: TextStyle(
                        fontSize: AppSizes.fontS,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Call rider functionality
                },
                icon: Icon(Icons.call, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.indigo;
      case 'picked_up':
      case 'out_for_delivery':
        return Colors.amber;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.inventory;
      case 'picked_up':
        return Icons.local_shipping;
      case 'out_for_delivery':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}