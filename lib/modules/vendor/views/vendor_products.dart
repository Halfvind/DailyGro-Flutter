import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vendor_controller.dart';
import '../../../themes/app_colors.dart';
import 'edit_product_screen.dart';

class VendorProducts extends StatelessWidget {
  const VendorProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VendorController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAddProductDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No products yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text('Tap + to add your first product'),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
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
                title: Text(product.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: \$${product.price.toStringAsFixed(2)}'),
                    Text('Stock: ${product.stock}',
                         style: TextStyle(color: product.stock < 10 ? Colors.red : Colors.green)),
                    Text('Category: ${product.category}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'stock', child: Text('Update Stock')),
                    PopupMenuItem(
                      value: product.isActive ? 'disable' : 'enable', 
                      child: Text(product.isActive ? 'Disable' : 'Enable'),
                    ),
                  ],
                  onSelected: (value) => _handleProductAction(value, product, controller),
                ),
              ),
            );
          },
        );
      }),
    );
  }
  
  void _handleProductAction(String action, product, VendorController controller) {
    switch (action) {
      case 'edit':
        Get.to(() => EditProductScreen(product: product));
        break;
      case 'stock':
        _showStockUpdateDialog(product, controller);
        break;
      case 'disable':
      case 'enable':
        Get.snackbar('Success', 'Product ${action}d');
        break;
    }
  }
  
  void _showStockUpdateDialog(product, VendorController controller) {
    final stockController = TextEditingController(text: product.stock.toString());
    Get.dialog(
      AlertDialog(
        title: Text('Update Stock - ${product.name}'),
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
            onPressed: () async {
              final newStock = int.tryParse(stockController.text);
              if (newStock != null) {
                final success = await controller.updateStock(product.id, newStock);
                Get.back();
                if (success) {
                  Get.snackbar('Success', 'Stock updated successfully');
                } else {
                  Get.snackbar('Error', 'Failed to update stock');
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
  
  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Add product logic
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}