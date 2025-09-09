import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../models/product_model.dart';
import '../../wishlist/controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
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
                    fontSize: AppSizes.fontL,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: AppSizes.height(8)),
                Text(
                  'Add items you love to see them here',
                  style: TextStyle(
                    fontSize: AppSizes.fontM,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(AppSizes.width(12)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSizes.width(12),
              mainAxisSpacing: AppSizes.height(12),
            ),
            itemCount: controller.wishlistItems.length,
            itemBuilder: (context, index) {
              final wishlistItem = controller.wishlistItems[index];
              
              // Convert WishlistModel to ProductModel for ProductCard
              final product = ProductModel(
                productId: wishlistItem.productId,
                vendorId: 0,
                categoryId: 0,
                name: wishlistItem.name,
                description: '',
                price: wishlistItem.price,
                originalPrice: wishlistItem.originalPrice,
                stockQuantity: 0,
                unit: wishlistItem.unit,
                weight: wishlistItem.weight,
                image: wishlistItem.image,
                isFeatured: wishlistItem.isFeatured,
                isRecommended: wishlistItem.isRecommended,
                rating: wishlistItem.rating,
                avgRating: 0,
                reviewCount: 0,
                categoryName: wishlistItem.categoryName,
                vendorName: wishlistItem.vendorName,
                vendorOwnerName: '',
                vendorRating: 0,
                discountPercentage: wishlistItem.discountPercentage,
                createdAt: wishlistItem.addedAt,
              );

              return ProductCard(product: product);
            },
          ),
        );
      }),
    );
  }
}