import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../../themes/app_colors.dart';
import '../../../product_detail/product_detail_view.dart';
import '../../controller/home_controller.dart';
import '../../../product/controllers/product_controller.dart';
import '../featured_products_view.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    
    return Obx(() {
      final products = productController.featuredProducts;
      if (products.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Products",
                style: TextStyle(
                  fontSize: AppSizes.sideHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(onTap:   (){
                Get.to(() => const FeaturedProductsView());
              },child: Container(
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
              ),)
            ],
          ),
          SizedBox(height: AppSizes.height(12)),
          SizedBox(
            height: AppSizes.height(290),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                 /* onTap: () => Get.to(() => ProductDetailView(product: products[index],),
                      arguments:{
                        "product": products[index],
                        "categoryId": products[index].categoryId,
                      }),*/
                  child: Container(
                    width: AppSizes.width(190),
                    margin: EdgeInsets.only(right: AppSizes.width(12)),
                    child: ProductCard(product: product),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
