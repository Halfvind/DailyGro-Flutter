import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../products/products_list_view.dart';
import '../../controller/home_controller.dart';

class CategoryList extends GetView<HomeController> {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
      if (categories.isEmpty) return const SizedBox.shrink();

      final displayCategories = categories.toList();

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: AppSizes.width(12),
          mainAxisSpacing: AppSizes.height(16),
          childAspectRatio: 0.85,
        ),
        itemCount: displayCategories.length > 8 ? 8 : displayCategories.length,
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          final colors = [
            [Color(0xFFE8F5E8), Color(0xFF4CAF50)], // Green
            [Color(0xFFFFF3E0), Color(0xFFFF9800)], // Orange
            [Color(0xFFE3F2FD), Color(0xFF2196F3)], // Blue
            [Color(0xFFFCE4EC), Color(0xFFE91E63)], // Pink
            [Color(0xFFF3E5F5), Color(0xFF9C27B0)], // Purple
            [Color(0xFFE0F2F1), Color(0xFF009688)], // Teal
            [Color(0xFFFFF8E1), Color(0xFFFFC107)], // Amber
            [Color(0xFFFFEBEE), Color(0xFFF44336)], // Red
          ];
          
          final colorPair = colors[index % colors.length];
          
          return GestureDetector(
           // onTap: () => Get.to(() => ProductsListView(category: category)),
            child: Container(
              decoration: BoxDecoration(
                color: colorPair[0],
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                border: Border.all(
                  color: colorPair[1].withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: AppSizes.width(40),
                    height: AppSizes.height(40),
                    decoration: BoxDecoration(
                      color: colorPair[1].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.name),
                      color: colorPair[1],
                      size: AppSizes.font(20),
                    ),
                  ),
                  AppSizes.vSpace(8),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: AppSizes.font(11),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'dairy':
        return Icons.local_drink;
      case 'beverages':
        return Icons.local_cafe;
      case 'snacks':
        return Icons.cookie;
      case 'bakery':
        return Icons.cake;
      case 'meat':
        return Icons.restaurant;
      case 'fish':
        return Icons.set_meal;
      case 'frozen':
        return Icons.ac_unit;
      case 'personal care':
        return Icons.face;
      case 'household':
        return Icons.home;
      case 'baby care':
        return Icons.child_care;
      case 'organic':
        return Icons.nature;
      case 'spices & herbs':
        return Icons.grass;
      case 'cereals & grains':
        return Icons.grain;
      case 'health & wellness':
        return Icons.health_and_safety;
      case 'pet care':
        return Icons.pets;
      case 'beauty':
        return Icons.face_retouching_natural;
      default:
        return Icons.category;
    }
  }
}
