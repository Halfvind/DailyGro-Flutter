import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vendor_controller.dart';
import '../../../themes/app_colors.dart';

class VendorStockManagement extends StatelessWidget {
  const VendorStockManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VendorController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/vendor/add-product'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStockSummary(),
          _buildFilterTabs(),
          Expanded(child: _buildProductList(controller)),
        ],
      ),
    );
  }

  Widget _buildStockSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildSummaryCard('Total Products', '45', Icons.inventory, Colors.blue)),
          Expanded(child: _buildSummaryCard('Low Stock', '8', Icons.warning, Colors.orange)),
          Expanded(child: _buildSummaryCard('Out of Stock', '3', Icons.error, Colors.red)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildFilterChip('All', true)),
          Expanded(child: _buildFilterChip('Low Stock', false)),
          Expanded(child: _buildFilterChip('Out of Stock', false)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildProductList(VendorController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
            title: Text('Product ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: \$${(index + 1) * 10}'),
                Text('Stock: ${index < 3 ? 'Low (${index + 2})' : '${(index + 1) * 5}'}',
                     style: TextStyle(color: index < 3 ? Colors.red : Colors.green)),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'stock', child: Text('Update Stock')),
                const PopupMenuItem(value: 'disable', child: Text('Disable')),
              ],
              onSelected: (value) => _handleProductAction(value, index),
            ),
          ),
        );
      },
    );
  }

  void _handleProductAction(String action, int index) {
    switch (action) {
      case 'edit':
        Get.toNamed('/vendor/edit-product', arguments: index);
        break;
      case 'stock':
        _showStockUpdateDialog(index);
        break;
      case 'disable':
        Get.snackbar('Success', 'Product disabled');
        break;
    }
  }

  void _showStockUpdateDialog(int index) {
    final stockController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Update Stock'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Stock Quantity',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'Stock updated successfully');
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}