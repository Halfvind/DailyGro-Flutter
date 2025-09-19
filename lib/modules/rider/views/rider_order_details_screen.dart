import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../controllers/rider_controller.dart';
import '../models/rider_order_model.dart';

class RiderOrderDetailsScreen extends StatelessWidget {
  final int orderId;
  final RiderController controller = Get.find<RiderController>();

  RiderOrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch order details when screen loads
    Future.microtask(() => controller.fetchOrderDetails(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final order = controller.selectedOrder.value;
        if (order == null) {
          return Center(child: Text('Order not found'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(order),
              SizedBox(height: 16),
              _buildCustomerInfo(order),
              SizedBox(height: 16),
              _buildVendorInfo(order),
              SizedBox(height: 16),
              _buildOrderItems(order),
              SizedBox(height: 16),
              _buildPaymentInfo(order),
              SizedBox(height: 16),
              _buildTrackingHistory(),
              SizedBox(height: 16),
              _buildActionButtons(order),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderHeader(RiderOrderModel order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Order ID: ${order.orderId}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Created: ${_formatDateTime(order.createdAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(RiderOrderModel order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(order.customerName),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(order.customerPhone),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(child: Text(order.customerAddress)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorInfo(RiderOrderModel order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pickup Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.store, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(order.vendorName),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(child: Text(order.vendorAddress)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(RiderOrderModel order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...order.items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('${item.productName} x${item.quantity}'),
                  ),
                  Text('₹${item.price.toStringAsFixed(2)}'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(RiderOrderModel order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Total:'),
                Text('₹${order.totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee:'),
                Text(
                  '₹${order.deliveryFee.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment Method:'),
                Text(order.paymentMethod.toUpperCase()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingHistory() {
    return Obx(() => Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tracking History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (controller.trackingHistory.isEmpty)
              Text('No tracking history available', style: TextStyle(color: Colors.grey))
            else
              ...controller.trackingHistory.map((history) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(top: 6, right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (history['status'] ?? '').toString().toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _formatDateTime(history['timestamp'] ?? ''),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          if (history['notes'] != null)
                            Text(
                              history['notes'].toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    ));
  }

  Widget _buildActionButtons(RiderOrderModel order) {
    switch (order.status.toLowerCase()) {
      case 'assigned':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.updateOrderStatus(order.orderId, 'picked_up'),
            child: Text('Mark as Picked Up'),
          ),
        );
      case 'picked_up':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.updateOrderStatus(order.orderId, 'delivered'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Mark as Delivered'),
          ),
        );
      default:
        return SizedBox();
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'assigned':
        color = Colors.blue;
        break;
      case 'picked_up':
        color = Colors.orange;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }
}