import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stock_management_controller.dart';
import '../repositories/vendor_repository.dart';
import '../../../data/api/api_client.dart';
import '../../../themes/app_colors.dart';

class VendorStockManagement extends StatefulWidget {
  const VendorStockManagement({super.key});

  @override
  State<VendorStockManagement> createState() => _VendorStockManagementState();
}

class _VendorStockManagementState extends State<VendorStockManagement> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies in correct order
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }
    if (!Get.isRegistered<VendorRepository>()) {
      Get.put(VendorRepository());
    }
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
            _buildSearchBar(controller),
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
          Expanded(child: _buildSummaryCard('Total Products', controller.totalProductsCount.value.toString(), Icons.inventory, Colors.blue)),
          Expanded(child: _buildSummaryCard('Low Stock', controller.totalLowStockProductsCount.value.toString(), Icons.warning, Colors.orange)),
          Expanded(child: _buildSummaryCard('Out of Stock', controller.totalOutOfStockProductsCount.value.toString(), Icons.error, Colors.red)),
          Expanded(child: _buildSummaryCard('Inactive', controller.totalInactiveProductsCount.value.toString(), Icons.block, Colors.grey)),
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
      child: Obx(
            () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('All', 'all', controller),
              const SizedBox(width: 8),
              _buildFilterChip('Low Stock', 'low', controller),
              const SizedBox(width: 8),
              _buildFilterChip('Out of Stock', 'out_of_stock', controller),
              const SizedBox(width: 8),
              _buildFilterChip('Inactive', 'inactive', controller),
            ],
          ),
        ),
      ),
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
                        image: NetworkImage('${product['image']}'),
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
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'toggle_status',
                  child: Text(product['status'] == 'active' ? 'Disable' : 'Enable'),
                ),
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
      case 'edit':
        Get.toNamed('/vendor/add-product', arguments: product);
        break;
      case 'toggle_status':
        final newStatus = product['status'] == 'active' ? 'inactive' : 'active';
        controller.updateProductStatus(product['product_id'], newStatus);
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

  Widget _buildSearchBar(StockManagementController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    controller.searchProducts('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild to show/hide clear button
          controller.searchProducts(value);
        },
      ),
    );
  }
}