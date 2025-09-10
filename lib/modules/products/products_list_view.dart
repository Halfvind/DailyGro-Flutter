import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../CommonComponents/CommonWidgets/api_product_card.dart';
import '../../themes/app_colors.dart';
import '../home/models/category_model.dart';
import 'controllers/products_controller.dart';

class ProductsListView extends StatelessWidget {
  final int? categoryId;
  
  const ProductsListView({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController());
    
    // Load products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productsController.loadProducts(categoryId: categoryId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (productsController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (productsController.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No products available'),
              ],
            ),
          );
        }
        
        return GridView.builder(
          padding: EdgeInsets.all(AppSizes.width(8)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
          ),
          itemCount: productsController.products.length,
          itemBuilder: (context, index) {
            return ApiProductCard(product: productsController.products[index]);
          },
        );
      }),
    );
  }
}