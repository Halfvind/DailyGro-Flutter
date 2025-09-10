import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../../../controllers/integrated_order_controller.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  
  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IntegratedOrderController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final order = controller.getOrderById(orderId);
        if (order == null) {
          return Center(child: Text('Order not found'));
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Info Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${order.orderNumber}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                      Text('Status: ${_getStatusText(order.status)}'),
                      Text('Delivery Address: ${order.deliveryAddress}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Order Status Timeline
              Text(
                'Order Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildStatusTimeline(order),
              
              SizedBox(height: 20),
              
              // Order Items
              Text(
                'Order Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ...order.items.map((item) => Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item.productName),
                  subtitle: Text('Quantity: ${item.quantity.value}'),
                  trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                ),
              )),
              
              SizedBox(height: 20),
              
              // Cancel Order Button (if applicable)
              if (order.status == 'placed')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _cancelOrder(orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Cancel Order'),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildStatusTimeline(order) {
    final statuses = [
      {'key': 'placed', 'title': 'Order Placed', 'time': order.orderDate},
      {'key': 'vendor_accepted', 'title': 'Vendor Accepted', 'time': order.vendorAcceptedAt},
      {'key': 'rider_assigned', 'title': 'Rider Assigned', 'time': order.riderAssignedAt},
      {'key': 'picked_up', 'title': 'Picked Up', 'time': order.pickedUpAt},
      {'key': 'delivered', 'title': 'Delivered', 'time': order.deliveredAt},
    ];
    
    return Column(
      children: statuses.map((status) {
        final isCompleted = _isStatusCompleted(order.status, status['key'] as String);
        final isCurrent = order.status == status['key'];
        
        return Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.green : 
                       isCurrent ? Colors.orange : Colors.grey[300],
              ),
              child: isCompleted ? Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['title'] as String,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? Colors.green : 
                             isCurrent ? Colors.orange : Colors.grey,
                    ),
                  ),
                  if (status['time'] != null)
                    Text(
                      _formatDateTime(status['time'] as DateTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
  
  bool _isStatusCompleted(String currentStatus, String checkStatus) {
    final statusOrder = ['placed', 'vendor_accepted', 'rider_assigned', 'picked_up', 'delivered'];
    final currentIndex = statusOrder.indexOf(currentStatus);
    final checkIndex = statusOrder.indexOf(checkStatus);
    return currentIndex >= checkIndex;
  }
  
  String _getStatusText(String status) {
    switch (status) {
      case 'placed': return 'Order Placed';
      case 'vendor_accepted': return 'Accepted by Vendor';
      case 'vendor_rejected': return 'Rejected by Vendor';
      case 'rider_assigned': return 'Rider Assigned';
      case 'picked_up': return 'Picked Up';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  void _cancelOrder(String orderId) {
    Get.dialog(
      AlertDialog(
        title: Text('Cancel Order'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              final controller = Get.find<IntegratedOrderController>();
              controller.userCancelOrder(orderId);
              Get.back();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}