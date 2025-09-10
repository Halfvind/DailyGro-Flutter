import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../../CommonComponents/CommonWidgets/api_product_card.dart';
import '../../../../themes/app_colors.dart';
import '../../../products/controllers/products_controller.dart';
import '../recommended_products_view.dart';

class RecommendedProducts extends StatelessWidget {
  const RecommendedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController(), tag: 'recommended');
    
    // Load recommended products when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productsController.loadRecommendedProducts();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended for you',
              style: TextStyle(
                fontSize: AppSizes.sideHeading,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => const RecommendedProductsView()),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width(12),
                  vertical: AppSizes.height(6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: AppSizes.font(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: AppSizes.height(12)),
        Obx(() {
          if (productsController.isLoading.value) {
            return SizedBox(
              height: AppSizes.height(290),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          if (productsController.products.isEmpty) {
            return SizedBox(
              height: AppSizes.height(290),
              child: Center(child: Text('No recommended products')),
            );
          }
          
          return SizedBox(
            height: AppSizes.height(290),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productsController.products.length > 10 ? 10 : productsController.products.length,
              itemBuilder: (context, index) {
                return Container(
                  width: AppSizes.width(190),
                  margin: EdgeInsets.only(right: AppSizes.width(12)),
                  child: ApiProductCard(product: productsController.products[index]),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}