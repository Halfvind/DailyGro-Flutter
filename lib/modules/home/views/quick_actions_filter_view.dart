import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../themes/app_colors.dart';
import '../../product_detail/product_detail_view.dart';
import '../data/all_products_data.dart';
import '../models/home_product_model.dart';

class QuickActionsFilterView extends StatelessWidget {
  final String filterType;
  
  const QuickActionsFilterView({super.key, required this.filterType});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();
    final title = _getFilterTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: AppSizes.font(64),
                    color: Colors.grey[400],
                  ),
                  AppSizes.vSpace(16),
                  Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: AppSizes.font(18),
                      color: Colors.grey[600],
                    ),
                  ),
                  AppSizes.vSpace(8),
                  Text(
                    'Try a different filter',
                    style: TextStyle(
                      fontSize: AppSizes.font(14),
                      color: Colors.grey[500],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.width(16)),
                    margin: EdgeInsets.only(bottom: AppSizes.height(16)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: AppColors.primary,
                          size: AppSizes.font(20),
                        ),
                        AppSizes.hSpace(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: AppSizes.font(16),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '${filteredProducts.length} products found',
                                style: TextStyle(
                                  fontSize: AppSizes.font(12),
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Products grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: AppSizes.width(12),
                        mainAxisSpacing: AppSizes.height(12),
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () => Get.to(() => ProductDetailView(product: product),
                              arguments: {
                                "product": product,
                                "categoryId": product.categoryId,
                              }),
                         /* child: ProductCard(product: product),*/
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<HomeProductModel> _getFilteredProducts() {
    final allProducts = getAllProducts().where((p) => p.isAvailable == true).toList();

    switch (filterType) {
      case 'price_under_50':
        return allProducts.where((p) => 
            p.variants.isNotEmpty && 
            p.variants[p.selectedVariantIndex.value].price < 50
        ).toList();
        
      case 'price_under_100':
        return allProducts.where((p) => 
            p.variants.isNotEmpty && 
            p.variants[p.selectedVariantIndex.value].price < 100
        ).toList();
        
      case 'organic':
        return allProducts.where((p) => p.categoryId == 5).toList(); // Organic category
        
      case 'best_rated':
        return allProducts.where((p) => 
            p.rating != null && p.rating >= 4.0
        ).toList();
        
      case 'all_products':
      default:
        return allProducts;
    }
  }

  String _getFilterTitle() {
    switch (filterType) {
      case 'price_under_50':
        return 'Products Under ₹50';
      case 'price_under_100':
        return 'Products Under ₹100';
      case 'organic':
        return 'Organic Products';
      case 'best_rated':
        return 'Best Rated Products';
      case 'all_products':
      default:
        return 'All Products';
    }
  }
}
