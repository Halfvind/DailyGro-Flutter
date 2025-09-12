import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stock_management_controller.dart';
import '../repositories/vendor_repository.dart';
import '../../../themes/app_colors.dart';

class VendorStockManagement extends StatelessWidget {
  const VendorStockManagement({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorRepository());
    final controller = Get.put(StockManagementController());
    
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Column(
          children: [
            _buildStockSummary(controller),
            _buildFilterTabs(controller),
            Expanded(child: _buildProductList(controller)),
          ],
        );
      }),
    );
  }

  Widget _buildStockSummary(StockManagementController controller) {
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
      child: Obx(() => Row(
        children: [
          Expanded(child: _buildSummaryCard('Total Products', controller.totalProducts.value.toString(), Icons.inventory, Colors.blue)),
          Expanded(child: _buildSummaryCard('Low Stock', controller.lowStockCount.value.toString(), Icons.warning, Colors.orange)),
          Expanded(child: _buildSummaryCard('Out of Stock', controller.outOfStockCount.value.toString(), Icons.error, Colors.red)),
        ],
      )),
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

  Widget _buildFilterTabs(StockManagementController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() => Row(
        children: [
          Expanded(child: _buildFilterChip('All', 'all', controller)),
          Expanded(child: _buildFilterChip('Low Stock', 'low', controller)),
          Expanded(child: _buildFilterChip('Out of Stock', 'out_of_stock', controller)),
        ],
      )),
    );
  }

  Widget _buildFilterChip(String label, String type, StockManagementController controller) {
    final isSelected = controller.selectedFilter.value == type;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            controller.loadProducts(type: type);
          }
        },
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildProductList(StockManagementController controller) {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        final stockColor = product['stock_quantity'] == 0 
            ? Colors.red 
            : product['stock_quantity'] <= 10 
                ? Colors.orange 
                : Colors.green;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: product['image'] != null 
                    ? DecorationImage(
                        image: NetworkImage('http://localhost/dailygro/uploads/products/${product['image']}'),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product['image'] == null ? const Icon(Icons.image, color: Colors.grey) : null,
            ),
            title: Text(product['name'] ?? 'Unknown Product'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: ₹${product['price'] ?? 0}'),
                Text('Stock: ${product['stock_quantity'] ?? 0}',
                     style: TextStyle(color: stockColor, fontWeight: FontWeight.w500)),
                if (product['status'] != null)
                  Text('Status: ${product['status']}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'stock', child: Text('Update Stock')),
                const PopupMenuItem(value: 'disable', child: Text('Disable')),
              ],
              onSelected: (value) => _handleProductAction(value, product, controller),
            ),
          ),
        );
      },
    ));
  }

  void _handleProductAction(String action, Map<String, dynamic> product, StockManagementController controller) {
    switch (action) {
      case 'stock':
        _showStockUpdateDialog(product, controller);
        break;
      case 'disable':
        Get.snackbar('Success', 'Product disabled');
        break;
    }
  }

  void _showStockUpdateDialog(Map<String, dynamic> product, StockManagementController controller) {
    final stockController = TextEditingController(text: product['stock_quantity'].toString());
    Get.dialog(
      AlertDialog(
        title: Text('Update Stock - ${product['name']}'),
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
              final newStock = int.tryParse(stockController.text) ?? 0;
              Get.back();
              controller.updateStock(product['product_id'], newStock);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}