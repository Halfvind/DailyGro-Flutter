import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../themes/app_colors.dart';
import '../data/all_products_data.dart';
import '../../product_detail/product_detail_view.dart';

class RecommendedProductsView extends StatelessWidget {
  const RecommendedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendedProducts = getRecommendedProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended for You'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: recommendedProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.recommend,
                    size: AppSizes.font(64),
                    color: Colors.grey[400],
                  ),
                  AppSizes.vSpace(16),
                  Text(
                    'No Recommended Products',
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
                itemCount: recommendedProducts.length,
                itemBuilder: (context, index) {
                  final product = recommendedProducts[index];
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
