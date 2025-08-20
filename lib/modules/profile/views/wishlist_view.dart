import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../themes/app_colors.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.find<WishlistController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (wishlistController.wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: AppSizes.font(80),
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSizes.height(16)),
                Text(
                  'Your wishlist is empty',
                  style: TextStyle(
                    fontSize: AppSizes.font(18),
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSizes.height(8)),
                Text(
                  'Add products you love to your wishlist',
                  style: TextStyle(
                    fontSize: AppSizes.font(14),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(AppSizes.width(16)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: AppSizes.width(12),
              mainAxisSpacing: AppSizes.height(12),
            ),
            itemCount: wishlistController.wishlistItems.length,
            itemBuilder: (context, index) {
              return ProductCard(product: wishlistController.wishlistItems[index]);
            },
          ),
        );
      }),
    );
  }
}