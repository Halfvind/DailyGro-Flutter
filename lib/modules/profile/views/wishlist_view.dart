import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/api_product_card.dart';
import '../../../themes/app_colors.dart';
import '../../wishlist/controllers/wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());
    
    // Load wishlist when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wishlistController.loadWishlist();
    });
    
    // Debug: Print wishlist items count
    ever(wishlistController.wishlistItems, (items) {
      print('WishlistView: Items count changed to ${items.length}');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (wishlistController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (wishlistController.wishlistItems.isEmpty) {
          print(wishlistController.wishlistItems.length);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSizes.height(16)),
                Text(
                  'Your wishlist is empty',
                  style: TextStyle(
                    fontSize: AppSizes.fontXL,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSizes.height(8)),
                Text(
                  'Add products you love to your wishlist',
                  style: TextStyle(
                    fontSize: AppSizes.fontM,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: AppSizes.height(24)),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width(32),
                      vertical: AppSizes.height(12),
                    ),
                  ),
                  child: Text(
                    'Start Shopping',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.fontL,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        return Padding(
          padding: EdgeInsets.all(AppSizes.width(8)),
          child: Column(
            children: [
              // Wishlist count
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.width(16)),
                margin: EdgeInsets.only(bottom: AppSizes.height(16)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                ),
                child: Text(
                  '${wishlistController.wishlistItems.length} items in your wishlist',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              
              // Wishlist items grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: AppSizes.width(8),
                    mainAxisSpacing: AppSizes.height(8),
                  ),
                  itemCount: wishlistController.wishlistItems.length,
                  itemBuilder: (context, index) {
                    final product = wishlistController.wishlistItems[index];
                    return ApiProductCard(product: product);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}