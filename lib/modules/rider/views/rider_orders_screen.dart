import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../controllers/rider_controller.dart';
import '../models/rider_models.dart';
import 'rider_map_screen.dart';

class RiderOrdersScreen extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Available'),
              Tab(text: 'My Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAvailableOrders(),
            _buildMyOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableOrders() {
    return Obx(() => controller.availableOrders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No available orders', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.availableOrders.length,
            itemBuilder: (context, index) {
              final order = controller.availableOrders[index];
              return _buildAvailableOrderCard(order);
            },
          ));
  }

  Widget _buildMyOrders() {
    return Obx(() => controller.myOrders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No active orders', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.myOrders.length,
            itemBuilder: (context, index) {
              final order = controller.myOrders[index];
              return _buildMyOrderCard(order);
            },
          ));
  }

  Widget _buildAvailableOrderCard(RiderOrder order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'NEW',
                    style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
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
            
            // Pickup Location
            Row(
              children: [
                Icon(Icons.store, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Expanded(child: Text('Pickup: ${order.vendorName}')),
              ],
            ),
            SizedBox(height: 4),
            
            // Delivery Location
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Expanded(child: Text('Deliver: ${order.customerAddress}')),
              ],
            ),
            SizedBox(height: 12),
            
            // Order Items
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items:', style: TextStyle(fontWeight: FontWeight.w500)),
                  ...order.items.map((item) => Text('• ${item.name} x${item.quantity}')),
                ],
              ),
            ),
            SizedBox(height: 12),
            
            // Amount and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                    Text(
                      'Delivery Fee: \$${order.deliveryFee.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.rejectOrder(order.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size(60, 36),
                      ),
                      child: Text('Reject'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => controller.acceptOrder(order.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(60, 36),
                      ),
                      child: Text('Accept'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyOrderCard(RiderOrder order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
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
            
            // Locations
            Row(
              children: [
                Icon(Icons.store, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Expanded(child: Text('${order.vendorName}')),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Expanded(child: Text('${order.customerAddress}')),
              ],
            ),
            SizedBox(height: 12),
            
            // Action Buttons
            if (order.status == 'accepted') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => RiderMapScreen(order: order)),
                  icon: Icon(Icons.navigation),
                  label: Text('Navigate to Pickup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.markOrderPicked(order.id),
                  icon: Icon(Icons.check_circle),
                  label: Text('Mark as Picked Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
            if (order.status == 'picked') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => RiderMapScreen(order: order)),
                  icon: Icon(Icons.navigation),
                  label: Text('Navigate to Customer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.markOrderDelivered(order.id),
                  icon: Icon(Icons.delivery_dining),
                  label: Text('Mark as Delivered'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
            if (order.status == 'delivered')
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Order Completed',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    
    switch (status) {
      case 'accepted':
        color = Colors.blue;
        text = 'ACCEPTED';
        break;
      case 'picked':
        color = Colors.orange;
        text = 'PICKED UP';
        break;
      case 'delivered':
        color = Colors.green;
        text = 'DELIVERED';
        break;
      default:
        color = Colors.grey;
        text = 'PENDING';
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