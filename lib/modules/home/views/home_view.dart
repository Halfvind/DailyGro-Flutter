import 'package:dailygro/modules/home/views/widgets/category_list.dart';
import 'package:dailygro/modules/home/views/widgets/featured_products.dart';
import 'package:dailygro/modules/home/views/widgets/recommended_products.dart';
import 'package:dailygro/modules/home/views/widgets/offers_banner.dart';
// Removed quick_actions_enhanced import
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../themes/app_colors.dart';
import 'widgets/ShimmerHomeLoader.dart';
import '../controller/home_controller.dart';
import 'widgets/home_header.dart';
import 'all_categories_view.dart';
import 'featured_products_view.dart';
import 'recommended_products_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  // ✅ Registering HomeController with GetX
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerHomeLoader();
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshHomeData,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.scaffoldBackground,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.p16),
                      child: Column(
                        children: [
                          const HomeHeader(),
                          AppSizes.vSpace(20),
                          const OffersBanner(),
                          AppSizes.vSpace(20),
                          // Removed QuickActionsEnhanced widget
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                    child: Column(
                      children: [
                        AppSizes.vSpace(10),
                        _buildSectionTitle('Shop by Category', 'View All'),

                        AppSizes.vSpace(12),
                        const CategoryList(),
                        AppSizes.vSpace(30),
                       /* const CategoryProducts(),
                        AppSizes.vSpace(20),*/
                      //  _buildSectionTitle('Featured Products', 'See All'),
                        AppSizes.vSpace(12),
                        const FeaturedProducts(),
                        AppSizes.vSpace(30),
                      //  _buildSectionTitle('Recommended for You', 'See All'),
                        AppSizes.vSpace(12),
                        const RecommendedProducts(),
                        AppSizes.vSpace(30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppSizes.font(20),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        GestureDetector(
          onTap: () {
            _navigateToSection(title);
          },
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
              actionText,
              style: TextStyle(
                fontSize: AppSizes.font(12),
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToSection(String sectionTitle) {
    switch (sectionTitle) {
      case 'Shop by Category':
        Get.to(() => const AllCategoriesView());
        break;
      case 'Featured Products':
        Get.to(() => const FeaturedProductsView());
        break;
      case 'Recommended for You':
        Get.to(() => const RecommendedProductsView());
        break;
    }
  }
}
