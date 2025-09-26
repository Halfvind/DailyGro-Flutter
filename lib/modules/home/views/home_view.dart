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
                          const HomeHeader(), // ✅ API integrated - shows user location and search
                          AppSizes.vSpace(20),
                          const OffersBanner(), // 🔄 Static data - TODO: Integrate with offers API
                          AppSizes.vSpace(20),
                          _buildQuickActions(), // 🔄 Static data - TODO: Integrate with services API
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
                        const CategoryList(), // ✅ API integrated - loads categories from API
                      /*  AppSizes.vSpace(30),
                        _buildSectionTitle('Featured Products', 'See All'),*/
                        AppSizes.vSpace(12),
                        const FeaturedProducts(), // ✅ API integrated - loads featured products
                       /* AppSizes.vSpace(30),
                        _buildSectionTitle('Recommended for You', 'See All'),*/
                        AppSizes.vSpace(12),
                        const RecommendedProducts(), // ✅ API integrated - loads recommended products
                        AppSizes.vSpace(30),
                        _buildDealsOfTheDay(), // 🔄 Static data - TODO: Integrate with deals API
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

  // 🔄 Static data - TODO: Integrate with services API
  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.flash_on, 'title': '10 Min', 'color': Colors.orange},
      {'icon': Icons.local_pharmacy, 'title': 'Pharmacy', 'color': Colors.red},
      {'icon': Icons.pets, 'title': 'Pet Care', 'color': Colors.purple},
      {'icon': Icons.cleaning_services, 'title': 'Cleaning', 'color': Colors.blue},
    ];

    return Container(
      height: AppSizes.height(80),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Container(
            width: AppSizes.width(80),
            margin: EdgeInsets.only(right: AppSizes.width(12)),
            decoration: BoxDecoration(
              color: (action['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radius(12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action['icon'] as IconData, color: action['color'] as Color, size: 24),
                AppSizes.vSpace(4),
                Text(action['title'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔄 Static data - TODO: Integrate with deals API
  Widget _buildDealsOfTheDay() {
    return Column(
      children: [
        _buildSectionTitle('Deals of the Day', 'View All'),
        AppSizes.vSpace(12),
        Container(
          height: AppSizes.height(120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: AppSizes.width(200),
                margin: EdgeInsets.only(right: AppSizes.width(12)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.local_offer, color: Colors.orange),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Deal ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Up to 40% OFF', style: TextStyle(color: Colors.green, fontSize: 12)),
                          Text('Limited time', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
