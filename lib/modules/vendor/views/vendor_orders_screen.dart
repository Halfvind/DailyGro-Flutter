import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders Management'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'New'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NewOrdersTab(),
            _ActiveOrdersTab(),
            _CompletedOrdersTab(),
            _CancelledOrdersTab(),
          ],
        ),
      ),
    );
  }
}

class _NewOrdersTab extends StatelessWidget {
  const _NewOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${1000 + index}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('New', style: TextStyle(color: Colors.orange, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Customer: John Doe ${index + 1}'),
                Text('Items: ${index + 2} items'),
                Text('Amount: \$${(index + 1) * 25}.00', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Order Time: ${DateTime.now().subtract(Duration(minutes: index * 15)).toString().substring(11, 16)}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectOrder(index),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptOrder(index),
                        child: const Text('Accept'),
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
  }

  void _acceptOrder(int index) {
    Get.snackbar('Success', 'Order #${1000 + index} accepted');
  }

  void _rejectOrder(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Reject Order'),
        content: const Text('Please select a reason for rejection:'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'Order rejected');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

class _ActiveOrdersTab extends StatelessWidget {
  const _ActiveOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${2000 + index}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Preparing', style: TextStyle(color: Colors.blue, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Customer: Jane Smith ${index + 1}'),
                Text('Items: ${index + 3} items'),
                Text('Amount: \$${(index + 2) * 30}.00', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _markReady(index),
                  child: const Text('Mark as Ready'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _markReady(int index) {
    Get.snackbar('Success', 'Order #${2000 + index} marked as ready for pickup');
  }
}

class _CompletedOrdersTab extends StatelessWidget {
  const _CompletedOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('Order #${3000 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: Customer ${index + 1}'),
                Text('Amount: \$${(index + 1) * 20}.00'),
                Text('Completed: ${DateTime.now().subtract(Duration(days: index + 1)).toString().substring(0, 10)}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Completed', style: TextStyle(color: Colors.green, fontSize: 12)),
            ),
          ),
        );
      },
    );
  }
}

class _CancelledOrdersTab extends StatelessWidget {
  const _CancelledOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('Order #${4000 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: Customer ${index + 1}'),
                Text('Amount: \$${(index + 1) * 15}.00'),
                Text('Reason: ${['Out of stock', 'Customer cancelled', 'Payment failed'][index]}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Cancelled', style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
        );
      },
    );
  }
}