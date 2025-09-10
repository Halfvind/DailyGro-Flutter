import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../themes/app_colors.dart';
import '../controller/home_controller.dart';
import '../../products/products_list_view.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final categories = controller.categories;
        if (categories.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.all(AppSizes.width(16)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSizes.width(12),
              mainAxisSpacing: AppSizes.height(12),
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => Get.to(() => ProductsListView(categoryId: category.categoryId)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          _getCategoryIcon(category.name ?? ''),
                          color: AppColors.primary,
                          size: AppSizes.font(30),
                        ),
                      ),
                      SizedBox(height: AppSizes.height(8)),
                      Text(
                        category.name ?? '',
                        style: TextStyle(
                          fontSize: AppSizes.font(12),
                          fontWeight: FontWeight.w600,
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
          ),
        );
      }),
    );
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