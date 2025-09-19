import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../controllers/rider_controller.dart';
import '../models/rider_order_model.dart';
import 'rider_order_details_screen.dart';

class RiderOrdersScreen extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

  @override
  Widget build(BuildContext context) {
    // Fetch orders when screen loads
    Future.microtask(() => controller.fetchRiderOrders());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Active Orders'),
              Tab(text: 'Completed Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActiveOrders(),
            _buildCompletedOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrders() {
    return Obx(() {
      if (controller.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.activeOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No active orders', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.activeOrders.length,
        itemBuilder: (context, index) {
          final order = controller.activeOrders[index];
          return _buildOrderCard(order, isActive: true);
        },
      );
    });
  }

  Widget _buildCompletedOrders() {
    return Obx(() {
      if (controller.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.completedOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No completed orders', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.completedOrders.length,
        itemBuilder: (context, index) {
          final order = controller.completedOrders[index];
          return _buildOrderCard(order, isActive: false);
        },
      );
    });
  }

  Widget _buildOrderCard(RiderOrderModel order, {required bool isActive}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Get.to(() => RiderOrderDetailsScreen(orderId: order.orderId)),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              SizedBox(height: 12),
              
              // Customer Info
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text('${order.customerName} • ${order.customerPhone}'),
                ],
              ),
              SizedBox(height: 8),
              
              // Addresses
              Row(
                children: [
                  Icon(Icons.store, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(child: Text('From: ${order.vendorName}')),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('To: ${order.customerAddress }')),
                ],
              ),

              SizedBox(height: 12),
              
              // Amount and Payment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: ₹${order.totalAmount}'),
                      Text(
                        'Delivery Fee: ₹${order.deliveryFee.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    order.paymentMethod.toUpperCase(),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              
              if (isActive) ...[
                SizedBox(height: 12),
                _buildActionButtons(order),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(RiderOrderModel order) {
    switch (order.status.toLowerCase()) {
      case 'ready':
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
    String text;
    
    switch (status.toLowerCase()) {
      case 'assigned':
        color = Colors.blue;
        text = 'ASSIGNED';
        break;
      case 'picked_up':
        color = Colors.orange;
        text = 'PICKED UP';
        break;
      case 'delivered':
        color = Colors.green;
        text = 'DELIVERED';
        break;
      default:
        color = Colors.grey;
        text = status.toUpperCase();
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}