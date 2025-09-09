import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../cart/controllers/cart_controller.dart';
import '../wishlist/controllers/wishlist_controller.dart';
import '../../themes/app_colors.dart';
import 'product_detail_controller.dart';
import '../../modules/home/models/home_product_model.dart';

class ProductDetailView extends StatelessWidget {
  final HomeProductModel product;
  ProductDetailView({super.key, required this.product});
  CartController get cartController => Get.find<CartController>();
  final ProductDetailController controller = Get.put(ProductDetailController());
  WishlistController get wishlistController => Get.find<WishlistController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),

          _buildProductDetails(),
          _buildSimilarProductsSection(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product-${product.id}',
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildProductDetails() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            AppSizes.vSpace(16),
            _buildPriceSection(),
            AppSizes.vSpace(16),
            _buildVariantSelector(),
            AppSizes.vSpace(16),
            _buildQuantitySelector(),
            AppSizes.vSpace(16),
            _buildProductDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: AppSizes.fontXXL,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        AppSizes.vSpace(8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: AppSizes.fontL),
            AppSizes.hSpace(4),
            Text(
              '${product.rating}',
              style: TextStyle(
                fontSize: AppSizes.fontL,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Obx(() {
      final price = product.currentPrice;
      final unit = product.currentUnit;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '₹${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: AppSizes.fontXXXL,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              AppSizes.hSpace(8),
              Text(
                '/ $unit',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildVariantSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Variant',
          style: TextStyle(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        AppSizes.vSpace(8),
        // Variants
        if (product.variants.isNotEmpty)
          SizedBox(
            height: AppSizes.height(30),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.variants.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected = product.selectedVariantIndex.value == index;
                  return GestureDetector(
                    onTap: () {
                      controller.updateVariant(index);
                      product.selectVariant(index);
                      },
                    child: Container(
                      margin: EdgeInsets.only(right: AppSizes.width(6)),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(10),
                        vertical: AppSizes.height(2),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey[100],
                        borderRadius: BorderRadius.circular(AppSizes.radius(14)),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          product.variants[index].unit,
                          style: TextStyle(
                            fontSize: AppSizes.font(10),
                            color: isSelected ? Colors.white : Colors.grey[700],
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
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Obx(() {
      return Row(
        children: [
          Text(
            'Quantity',
            style: TextStyle(
              fontSize: AppSizes.fontL,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          AppSizes.hSpace(16),
         /* Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: controller.decrementQuantity,
              ),
              Text(
                '${controller.quantity.value}',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: controller.incrementQuantity,
              ),
            ],
          ),*/
          _buildCartButton()
        ],
      );
    });
  }
  Widget _buildCartButton() {
    final quantity = cartController.getProductQuantity(
      product.id, product.selectedVariantIndex.value,
    );

    if (quantity == 0) {
      return GestureDetector(
       /* onTap: () => cartController.addToCart(
          product,
          variantIndex: product.selectedVariantIndex.value,
        ),*/
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(16),
            vertical: AppSizes.height(8),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radius(20)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'ADD',
            style: TextStyle(
              fontSize: AppSizes.font(12),
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _qtyButton(Icons.remove, () {
              final cartIndex = cartController.cartItems.indexWhere((item) =>
              item.product.productId == product.id &&
                  item.selectedVariantIndex.value ==
                      product.selectedVariantIndex.value);
              if (cartIndex != -1) {
                cartController.updateItemQuantity(cartIndex, quantity - 1);
              }
            }),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(8),
                vertical: AppSizes.height(4),
              ),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: AppSizes.font(12),
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _qtyButton(Icons.add, () {
              final cartIndex = cartController.cartItems.indexWhere((item) =>
              item.product.productId == product.id &&
                  item.selectedVariantIndex.value ==
                      product.selectedVariantIndex.value);
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
        padding: EdgeInsets.all(AppSizes.width(8)),
        child: Icon(
          icon,
          size: AppSizes.font(14),
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _buildProductDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        AppSizes.vSpace(8),
        Text(
          controller.product.description,
          style: TextStyle(
            fontSize: AppSizes.fontM,
            color: AppColors.secondaryText,
          ),
        ),

        SizedBox(height: AppSizes.height(6)),



      ],
    );
  }

  Widget _buildSimilarProductsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Similar Products',
              style: TextStyle(
                fontSize: AppSizes.fontXXL,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
           // AppSizes.vSpace(5),
            Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemCount: controller.similarProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.similarProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(HomeProductModel product) {
    return GestureDetector(

      onTap: () {
       /* Get.toNamed('/productDetail', arguments: {
          'product': product,
          'categoryId': product.categoryId,
        });*/
      },
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(AppSizes.width(12)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: AppSizes.height(320), // Increased height for offer pricing
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  height: AppSizes.height(90),
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
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                height: AppSizes.height(90),
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
                        child: Obx(() => GestureDetector(
                          onTap: () => wishlistController.toggleWishlist(product),
                          child: _buildWishlistIcon(
                            wishlistController.isInWishlist(product.id),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.height(8)),

                // Product Name (flexible to avoid overflow)
                Flexible(
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: AppSizes.height(4)),

                // Rating
                if (product.rating > 0)
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

                SizedBox(height: AppSizes.height(6)),

                // Variants
                if (product.variants.isNotEmpty)
                  SizedBox(
                    height: AppSizes.height(28),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.variants.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isSelected = product.selectedVariantIndex.value == index;
                          return GestureDetector(
                            onTap: () => product.selectVariant(index),
                            child: Container(
                              margin: EdgeInsets.only(right: AppSizes.width(6)),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.width(10),
                                vertical: AppSizes.height(2),
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryDark],
                                )
                                    : null,
                                color: isSelected ? null : Colors.grey[100],
                                borderRadius: BorderRadius.circular(AppSizes.radius(14)),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  product.variants[index].unit,
                                  style: TextStyle(
                                    fontSize: AppSizes.font(10),
                                    color: isSelected ? Colors.white : Colors.grey[700],
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
                AppSizes.vSpace(10),

                //  Spacer(),

                // Price + Add Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildSimilarProductPriceSection(product)),
                    Obx(() => _buildSimilarProductCartButton(product)),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: AppSizes.radius(10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              text: 'Add to Cart',
              onPressed: () {
                // Add to cart logic
              },
            ),
          ),
          AppSizes.hSpace(16),
          Expanded(
            child: CommonButton(
              text: 'Buy Now',
              onPressed: () {
                // Buy now logic
              },
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

  Widget _buildSimilarProductPriceSection(HomeProductModel product) {
    return Obx(() {
      final price = product.variants[product.selectedVariantIndex.value].price;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '₹${price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: AppSizes.font(18),
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          if (price > 50) ...[
            Text(
              '₹${(price * 1.2).toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: AppSizes.font(12),
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              '${((1.2 - 1) * 100).toInt()}% OFF',
              style: TextStyle(
                fontSize: AppSizes.font(9),
                color: AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildSimilarProductCartButton(HomeProductModel product) {
    final quantity = cartController.getProductQuantity(
      product.id, product.selectedVariantIndex.value,
    );

    if (quantity == 0) {
      return GestureDetector(
       /* onTap: () => cartController.addToCart(
          product.id,

          variantIndex: product.selectedVariantIndex.value,
        ),*/
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(12),
            vertical: AppSizes.height(6),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
          ),
          child: Text(
            'ADD',
            style: TextStyle(
              fontSize: AppSizes.font(10),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _qtyButton(Icons.remove, () {
              final cartIndex = cartController.cartItems.indexWhere((item) =>
              item.product.productId == product.id &&
                  item.selectedVariantIndex.value ==
                      product.selectedVariantIndex.value);
              if (cartIndex != -1) {
                cartController.updateItemQuantity(cartIndex, quantity - 1);
              }
            }),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(6),
                vertical: AppSizes.height(2),
              ),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: AppSizes.font(10),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _qtyButton(Icons.add, () {
              final cartIndex = cartController.cartItems.indexWhere((item) =>
              item.product.productId == product.id &&
                  item.selectedVariantIndex.value ==
                      product.selectedVariantIndex.value);
              if (cartIndex != -1) {
                cartController.updateItemQuantity(cartIndex, quantity + 1);
              }
            }),
          ],
        ),
      );
    }
  }

}
