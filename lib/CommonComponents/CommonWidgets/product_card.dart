import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../modules/home/models/home_product_model.dart';
import '../../themes/app_colors.dart';
import '../CommonUtils/app_sizes.dart';

class ProductCard extends StatelessWidget {
  final HomeProductModel product;

  const ProductCard({super.key, required this.product});

  CartController get cartController => Get.find<CartController>();
  WishlistController get wishlistController => Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSizes.width(6)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: AppSizes.height(150),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radius(12)),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          height: AppSizes.height(150),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.local_grocery_store,
                                size: AppSizes.font(45),
                                color: AppColors.primary.withOpacity(0.6),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.local_grocery_store,
                            size: AppSizes.font(45),
                            color: AppColors.primary.withOpacity(0.6),
                          ),
                        ),
                ),
                if (product.isFeatured == true)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: _buildTag("Featured", AppColors.warning),
                  ),
                if (product.isBestSeller == true)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _buildTag("Best Seller", AppColors.info),
                  ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () => wishlistController.toggleWishlist(product),
                      child: _buildWishlistIcon(
                        wishlistController.isInWishlist(product.id!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppSizes.vSpace(6),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.width(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name ?? '',
                    style: TextStyle(
                      fontSize: AppSizes.font(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSizes.vSpace(2),

                  // Rating
                  if (product.rating != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(6),
                        vertical: AppSizes.height(2),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: AppSizes.font(12),
                            color: Colors.amber[700],
                          ),
                          SizedBox(width: AppSizes.width(2)),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              fontSize: AppSizes.font(11),
                              color: Colors.amber[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  AppSizes.vSpace(2),

                  // Variants
                  if (product.variants.isNotEmpty)
                    SizedBox(
                      height: AppSizes.height(20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.variants.length,
                        itemBuilder: (context, index) {
                          return Obx(() {
                            final isSelected =
                                product.selectedVariantIndex.value == index;
                            return GestureDetector(
                              onTap: () => product.selectVariant(index),
                              child: Container(
                                margin: EdgeInsets.only(right: AppSizes.width(6)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.width(8),
                                  vertical: AppSizes.height(1),
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radius(12),
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    product.variants[index].unit,
                                    style: TextStyle(
                                      fontSize: AppSizes.font(9),
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),

                //  const Spacer(),

                  // Price + Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildPriceSection(),
                      Obx(() => _buildCartButton()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(6),
        vertical: AppSizes.height(2),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radius(8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSizes.font(8),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWishlistIcon(bool isInWishlist) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(4)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isInWishlist ? Icons.favorite : Icons.favorite_border,
        size: AppSizes.font(16),
        color: isInWishlist ? Colors.red : Colors.grey[600],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Obx(() {
      final price = product.variants[product.selectedVariantIndex.value].price;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '₹${price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: AppSizes.font(16),
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          if (price > 50) ...[
            Row(
              children: [
                Text(
                  '₹${(price * 1.2).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: AppSizes.font(10),
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: AppSizes.width(4)),
                Text(
                  '${((1.2 - 1) * 100).toInt()}% OFF',
                  style: TextStyle(
                    fontSize: AppSizes.font(8),
                    color: AppColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }

  Widget _buildCartButton() {
    final quantity = cartController.getProductQuantity(
      product.id!,
      product.selectedVariantIndex.value,
    );

    if (quantity == 0) {
      // ✅ Stylish ADD button
      return GestureDetector(
        onTap: () => cartController.addToCart(
          product,
          variantIndex: product.selectedVariantIndex.value,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(5),
            vertical: AppSizes.height(2),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 1.2),
            borderRadius: BorderRadius.circular(AppSizes.radius(20)),
          ),
          child: Text(
            "+ ADD",
            style: TextStyle(
              fontSize: AppSizes.font(12),
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else {
      // ✅ Stepper when item is added
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _qtyButton(Icons.remove, () {
              final cartIndex = cartController.cartItems.indexWhere(
                    (item) =>
                item.product.id == product.id &&
                    item.selectedVariantIndex.value ==
                        product.selectedVariantIndex.value,
              );
              if (cartIndex != -1) {
                cartController.updateItemQuantity(cartIndex, quantity - 1);
              }
            }),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(10),
                vertical: AppSizes.height(4),
              ),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: AppSizes.font(5),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            _qtyButton(Icons.add, () {
              final cartIndex = cartController.cartItems.indexWhere(
                    (item) =>
                item.product.id == product.id &&
                    item.selectedVariantIndex.value ==
                        product.selectedVariantIndex.value,
              );
              if (cartIndex != -1) {
                cartController.updateItemQuantity(cartIndex, quantity + 1);
              }
            }),
          ],
        ),
      );
    }
  }


  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width(3),
          vertical: AppSizes.height(1),
        ),
        child: Icon(icon, size: AppSizes.font(10), color: Colors.white,weight: 700,),
      ),
    );
  }
}
