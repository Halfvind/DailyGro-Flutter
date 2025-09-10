import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/api_product_card.dart';
import '../../../themes/app_colors.dart';
import '../../products/controllers/products_controller.dart';

class FeaturedProductsView extends StatelessWidget {
  const FeaturedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController(), tag: 'featured_view');
    
    // Load featured products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productsController.loadFeaturedProducts();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Products'),
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
                Icon(Icons.star_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No Featured Products'),
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
