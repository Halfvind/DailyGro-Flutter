import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../themes/app_colors.dart';
import '../data/all_products_data.dart';
import '../../product_detail/product_detail_view.dart';

class FeaturedProductsView extends StatelessWidget {
  const FeaturedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredProducts = getFeaturedProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Products'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: featuredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: AppSizes.font(64),
                    color: Colors.grey[400],
                  ),
                  AppSizes.vSpace(16),
                  Text(
                    'No Featured Products',
                    style: TextStyle(
                      fontSize: AppSizes.font(18),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width(12),
          vertical: AppSizes.height(6),
        ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: AppSizes.width(12),
                  mainAxisSpacing: AppSizes.height(12),
                ),
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = featuredProducts[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => ProductDetailView(product: product),
                        arguments: {
                          "product": product,
                          "categoryId": product.categoryId,
                        }),
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
    );
  }
}
