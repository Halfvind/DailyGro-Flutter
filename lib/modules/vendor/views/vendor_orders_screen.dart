import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../controllers/vendor_controller.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VendorController _vendorController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    
    // Initialize controller
    try {
      _vendorController = Get.find<VendorController>();
    } catch (e) {
      print('VendorController not found, creating new instance: $e');
      _vendorController = Get.put(VendorController());
    }
    
    // Load orders after controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders('new');
    });
  }

  void _onTabChanged() {
    final statuses = ['new', 'active', 'complete', 'cancelled'];
    _loadOrders(statuses[_tabController.index]);
  }

  void _loadOrders(String status) {
    _vendorController.loadVendorOrders(status);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'New'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NewOrdersTab(vendorController: _vendorController),
          _ActiveOrdersTab(vendorController: _vendorController),
          _CompletedOrdersTab(vendorController: _vendorController),
          _CancelledOrdersTab(vendorController: _vendorController),
        ],
      ),
    );
  }
}

class _NewOrdersTab extends StatelessWidget {
  final VendorController vendorController;
  const _NewOrdersTab({required this.vendorController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (vendorController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final orders = vendorController.orders;
      if (orders.isEmpty) {
        return const Center(child: Text('No new orders'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, isNew: true);
        },
      );
    });
  }

  Widget _buildOrderCard(dynamic order, {bool isNew = false}) {
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order['order_number'] ?? order['order_id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'ID: ${order['order_id']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status'] ?? 'pending').withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (order['status'] ?? 'pending').toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(order['status'] ?? 'pending'),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildOrderDetails(order),
            const SizedBox(height: 8),
            _buildOrderItems(order),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment: ${order['payment_method']?.toUpperCase() ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Order Time: ${_formatDateTime(order['created_at'])}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(
                  '₹${order['total_amount'] ?? '0.00'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isNew)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectOrder(order['order_id']),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptOrder(order['order_id']),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Customer: ${order['delivery_name'] ?? 'N/A'}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Phone: ${order['delivery_phone'] ?? 'N/A'}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Address: ${order['address_line'] ?? ''}, ${order['city'] ?? ''}, ${order['state'] ?? ''} - ${order['pincode'] ?? ''}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(dynamic order) {
    if (order['order_items'] == null || !(order['order_items'] is List)) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
          const SizedBox(height: 4),
          ...((order['order_items'] as List).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${item['product_name']} x${item['quantity']}', style: const TextStyle(fontSize: 13)),
                ),
                Text('₹${item['total_price']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ))),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }

  void _acceptOrder(int orderId) async {
    final success = await vendorController.acceptOrder(orderId);
    if (success) vendorController.loadVendorOrders('new');
  }

  void _rejectOrder(int orderId) {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Reject Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please provide a reason');
                return;
              }
              Get.back();
              final success = await vendorController.rejectOrder(orderId, reasonController.text.trim());
              if (success) vendorController.loadVendorOrders('new');
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
  final VendorController vendorController;
  const _ActiveOrdersTab({required this.vendorController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (vendorController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final orders = vendorController.orders;
      if (orders.isEmpty) {
        return const Center(child: Text('No active orders'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      );
    });
  }

  Widget _buildOrderCard(dynamic order) {
    final bool isReady = order['status'] == 'ready';

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
                Expanded(
                  child: Text(
                    'Order #${order['order_number'] ?? order['order_id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (order['status'] ?? 'active').toUpperCase(),
                    style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildOrderDetails(order),
            const SizedBox(height: 8),
            _buildOrderItems(order),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment: ${order['payment_method']?.toUpperCase() ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  '₹${order['total_amount'] ?? '0.00'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Show either the button or status
            isReady
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Ready for Delivery',
                style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            )
                : ElevatedButton(
              onPressed: () => _markReady(order['order_id']),
              child: const Text('Mark as Ready'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOrderDetails(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Customer: ${order['delivery_name'] ?? 'N/A'}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Phone: ${order['delivery_phone'] ?? 'N/A'}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(dynamic order) {
    if (order['order_items'] == null || !(order['order_items'] is List)) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
          const SizedBox(height: 4),
          ...((order['order_items'] as List).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${item['product_name']} x${item['quantity']}', style: const TextStyle(fontSize: 13)),
                ),
                Text('₹${item['total_price']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ))),
        ],
      ),
    );
  }

  void _markReady(int orderId) async {
    final success = await vendorController.markOrderReady(orderId);
    if (success) vendorController.loadVendorOrders('active');
  }
}
class _CompletedOrdersTab extends StatelessWidget {
  final VendorController vendorController;
  const _CompletedOrdersTab({required this.vendorController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (vendorController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final orders = vendorController.orders;
      if (orders.isEmpty) {
        return const Center(child: Text('No completed orders'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order['order_number'] ?? order['order_id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderDetails(order),
                  const SizedBox(height: 8),
                  _buildOrderItems(order),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment: ${order['payment_method']?.toUpperCase() ?? 'N/A'}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      Text('₹${order['total_amount'] ?? '0.00'}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('COMPLETED', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOrderDetails(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Customer: ${order['delivery_name'] ?? 'N/A'}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Phone: ${order['delivery_phone'] ?? 'N/A'}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(dynamic order) {
    if (order['order_items'] == null || !(order['order_items'] is List)) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
          const SizedBox(height: 4),
          ...((order['order_items'] as List).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${item['product_name']} x${item['quantity']}', style: const TextStyle(fontSize: 13)),
                ),
                Text('₹${item['total_price']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ))),
        ],
      ),
    );
  }
}
class _CancelledOrdersTab extends StatelessWidget {
  final VendorController vendorController;
  const _CancelledOrdersTab({required this.vendorController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (vendorController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final orders = vendorController.orders;
      if (orders.isEmpty) {
        return const Center(child: Text('No cancelled orders'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order['order_number'] ?? order['order_id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderDetails(order),
                  const SizedBox(height: 8),
                  _buildOrderItems(order),
                  const SizedBox(height: 8),
                  Text('Cancellation Reason: ${order['cancellation_reason'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('CANCELLED', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOrderDetails(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Customer: ${order['delivery_name'] ?? 'N/A'}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Phone: ${order['delivery_phone'] ?? 'N/A'}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(dynamic order) {
    if (order['order_items'] == null || !(order['order_items'] is List)) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
          const SizedBox(height: 4),
          ...((order['order_items'] as List).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${item['product_name']} x${item['quantity']}', style: const TextStyle(fontSize: 13)),
                ),
                Text('₹${item['total_price']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ))),
        ],
      ),
    );
  }
}


