import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/api_product_model.dart';
import '../../modules/cart/controllers/cart_controller.dart';
import '../../modules/product_detail/product_detail_view.dart';
import '../../modules/wishlist/controllers/wishlist_controller.dart';
import '../../themes/app_colors.dart';
import '../CommonUtils/app_sizes.dart';

class ApiProductCard extends StatelessWidget {
  final ApiProductModel product;

  const ApiProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailView(productId: product.productId)),
      child: Container(
      margin: EdgeInsets.all(AppSizes.width(6)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radius(12)),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                  child: product.image != null && product.image!.isNotEmpty
                      ? Image.network(
                    product!.image!.startsWith('http')?'${product.image}': 'http://localhost/dailygro/uploads/${product.image}',
                          height: AppSizes.height(150),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.local_grocery_store,
                                size: AppSizes.font(45),
                                color: AppColors.primary.withValues(alpha: 0.6),
                              ),
                            );
                          },
                        )

                      : Center(
                          child: Icon(
                            Icons.local_grocery_store,
                            size: AppSizes.font(45),
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                ),
                if (product.isFeatured)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: _buildTag("Featured", AppColors.warning),
                  ),
                if (product.isRecommended)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _buildTag("Recommended", AppColors.info),
                  ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: _buildWishlistButton(),
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
                    product.name,
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
                  if (product.rating > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(6),
                        vertical: AppSizes.height(2),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
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
                            product.rating.toStringAsFixed(1),
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

                  // Unit display
                  Text(
                    '${product.weight} ${product.unit}',
                    style: TextStyle(
                      fontSize: AppSizes.font(10),
                      color: Colors.grey[600],
                    ),
                  ),

                  const Spacer(),

                  // Price + Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceSection(),
                      _buildCartButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '₹${product.price}',
          style: TextStyle(
            fontSize: AppSizes.font(16),
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        if (product.originalPrice > product.price) ...[
          Row(
            children: [
              Text(
                '₹${product.originalPrice}',
                style: TextStyle(
                  fontSize: AppSizes.font(10),
                  color: Colors.grey[500],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: AppSizes.width(4)),
              Text(
                '${product.discountPercentage}% OFF',
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
  }

  Widget _buildCartButton() {
    return Obx(() {
      try {
        final cartController = Get.find<CartController>();
        final cartItem = cartController.cartItems.firstWhereOrNull((item) => item.productId == product.productId);
        final isInCart = cartItem != null;
        
        if (isInCart) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radius(20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (cartItem!.quantity > 1) {
                      cartController.updateCartItem(cartItem.cartId, cartItem.quantity - 1);
                    } else {
                      cartController.removeFromCart(cartItem.cartId);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.width(4)),
                    child: Icon(
                      Icons.remove,
                      size: AppSizes.font(12),
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.width(8),
                    vertical: AppSizes.height(4),
                  ),
                  child: Text(
                    cartItem!.quantity.toString(),
                    style: TextStyle(
                      fontSize: AppSizes.font(12),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cartController.updateCartItem(cartItem.cartId, cartItem.quantity + 1);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.width(4)),
                    child: Icon(
                      Icons.add,
                      size: AppSizes.font(12),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        return GestureDetector(
          onTap: () {
            cartController.addToCart(product.productId, 1);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(12),
              vertical: AppSizes.height(6),
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
      } catch (e) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(12),
            vertical: AppSizes.height(6),
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
        );
      }
    });
  }

  Widget _buildWishlistButton() {
    return GetBuilder<WishlistController>(
      id: 'wishlist_${product.productId}',
      init: Get.find<WishlistController>(),
      builder: (wishlistController) {
        final isInWishlist = wishlistController.isInWishlist(product.productId);
        
        return GestureDetector(
          onTap: () async {
            if (isInWishlist) {
              await wishlistController.removeFromWishlist(product.productId);
            } else {
              await wishlistController.addToWishlist(product.productId);
            }
            wishlistController.update(['wishlist_${product.productId}']);
          },
          child: Container(
            padding: EdgeInsets.all(AppSizes.width(4)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              size: AppSizes.font(16),
              color: isInWishlist ? Colors.red : Colors.grey[600],
            ),
          ),
        );
      },
    );
  }
}