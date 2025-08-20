import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../../themes/app_colors.dart';
import '../../data/all_products_data.dart';
import '../quick_actions_filter_view.dart';

class QuickActionsEnhanced extends StatelessWidget {
  const QuickActionsEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    final quickItems = [
      {
        'title': 'Price Under\n₹50',
        'image': '💰',
        'filter': 'price_under_50',
        'bgColor': Color(0xFFFFF3E0),
      },
      {
        'title': 'Price Under\n₹100',
        'image': '💵',
        'filter': 'price_under_100',
        'bgColor': Color(0xFFE8F5E8),
      },
      {
        'title': 'Organic\nProducts',
        'image': '🌱',
        'filter': 'organic',
        'bgColor': Color(0xFFE3F2FD),
      },
      {
        'title': 'Best Rated\n4+ Stars',
        'image': '⭐',
        'filter': 'best_rated',
        'bgColor': Color(0xFFFCE4EC),
      },
    ];

    return Column(
      children: [
        // Quick filter items grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.width(12),
            mainAxisSpacing: AppSizes.height(12),
            childAspectRatio: 1.6,
          ),
          itemCount: quickItems.length,
          itemBuilder: (context, index) {
            final item = quickItems[index];
            return GestureDetector(
              onTap: () => _navigateToFilteredProducts(item['filter'] as String),
              child: Container(
                decoration: BoxDecoration(
                  color: item['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.width(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: AppSizes.font(13),
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            item['image'] as String,
                            style: TextStyle(fontSize: AppSizes.font(24)),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.width(12),
                          vertical: AppSizes.height(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                        ),
                        child: Text(
                          _getProductCount(item['filter'] as String),
                          style: TextStyle(
                            fontSize: AppSizes.font(12),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        AppSizes.vSpace(20),
        // Grocery & Kitchen section
        GestureDetector(
          onTap: () => _navigateToFilteredProducts('all_products'),
          child: Container(
            padding: EdgeInsets.all(AppSizes.width(16)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radius(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.width(60),
                  height: AppSizes.height(60),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E8),
                    borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                  ),
                  child: Center(
                    child: Text(
                      '🥬',
                      style: TextStyle(fontSize: AppSizes.font(28)),
                    ),
                  ),
                ),
                AppSizes.hSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: AppSizes.font(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      AppSizes.vSpace(4),
                      Text(
                        'Browse all available products',
                        style: TextStyle(
                          fontSize: AppSizes.font(12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppSizes.font(16),
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToFilteredProducts(String filterType) {
    Get.to(() => QuickActionsFilterView(filterType: filterType));
  }

  String _getProductCount(String filterType) {
    final products = getAllProducts();
    int count = 0;

    switch (filterType) {
      case 'price_under_50':
        count = products.where((p) => p.variants.isNotEmpty && 
            p.variants[p.selectedVariantIndex.value].price < 50).length;
        break;
      case 'price_under_100':
        count = products.where((p) => p.variants.isNotEmpty && 
            p.variants[p.selectedVariantIndex.value].price < 100).length;
        break;
      case 'organic':
        count = products.where((p) => p.categoryId == 5).length; // Organic category
        break;
      case 'best_rated':
        count = products.where((p) => p.rating != null && p.rating >= 4.0).length;
        break;
      default:
        count = products.length;
    }

    return '$count items';
  }
}
