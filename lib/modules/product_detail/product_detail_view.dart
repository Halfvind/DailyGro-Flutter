import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../CommonComponents/CommonWidgets/api_product_card.dart';
import '../cart/controllers/cart_controller.dart';
import '../wishlist/controllers/wishlist_controller.dart';
import '../../themes/app_colors.dart';
import 'controllers/api_product_detail_controller.dart';

class ProductDetailView extends StatelessWidget {
  final int productId;
  
  const ProductDetailView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApiProductDetailController());
    final cartController = Get.find<CartController>();
    final wishlistController = Get.find<WishlistController>();
    
    // Load product detail when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProductDetail(productId);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.productDetail.value == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Product not found'),
              ],
            ),
          );
        }
        
        final product = controller.productDetail.value!.product;
        final similarProduct = controller.productDetail.value!.similarProducts;
        
        return CustomScrollView(
          slivers: [
            // Product Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: product?.image != null
                    ? Image.network(
                  product!.image!.startsWith("http")
                      ? product.image!
                      : "http://localhost/dailygro/uploads/${product.image}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 64, color: Colors.grey),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              ),
            ),


            // Product Details
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.width(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product!.name,
                      style: TextStyle(
                        fontSize: AppSizes.fontXXL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: AppSizes.height(8)),
                    
                    // Rating
                    if (product.rating > 0)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: AppSizes.fontL),
                          SizedBox(width: AppSizes.width(4)),
                          Text('${product.rating.toStringAsFixed(1)} (reviews)'),
                        ],
                      ),
                    
                    SizedBox(height: AppSizes.height(16)),
                    
                    // Price
                    Row(
                      children: [
                        Text(
                          '₹${product.price}',
                          style: TextStyle(
                            fontSize: AppSizes.fontXXL,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          SizedBox(width: AppSizes.width(8)),
                          Text(
                            '₹${product.originalPrice}',
                            style: TextStyle(
                              fontSize: AppSizes.fontL,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: AppSizes.width(8)),
                          Text(
                            '${product.discountType}% OFF',
                            style: TextStyle(
                              fontSize: AppSizes.fontM,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    SizedBox(height: AppSizes.height(8)),
                    
                    // Unit
                    Text(
                      '${product.weight} ${product.unit}',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    SizedBox(height: AppSizes.height(16)),
                    
                    // Quantity Selector
                    Row(
                      children: [
                        Text(
                          'Quantity:',
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppSizes.width(16)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: controller.decrementQuantity,
                                icon: Icon(Icons.remove),
                              ),
                              Obx(() => Text(
                                '${controller.quantity.value}',
                                style: TextStyle(
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              IconButton(
                                onPressed: controller.incrementQuantity,
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppSizes.height(16)),
                    
                    // Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizes.height(8)),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: AppSizes.fontM,
                        color: Colors.grey[700],
                      ),
                    ),
                    
                    SizedBox(height: AppSizes.height(24)),
                    
                    // Similar Products

                    if (similarProduct.isNotEmpty) ...[
                      Text(
                        'Similar Products',
                        style: TextStyle(
                          fontSize: AppSizes.fontXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.height(12)),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: similarProduct.length,
                        itemBuilder: (context, index) {
                          final similar = similarProduct[index];
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.20,
                                  child: similar.image != null
                                      ? Image.network(
                                    similar.image!.startsWith("http")?"${similar.image}":
                                          'http://localhost/dailygro/uploads/${similar.image}',
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(Icons.image, color: Colors.grey),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: Colors.grey[200],
                                          child: Icon(Icons.image, color: Colors.grey),
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        similar.name,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text('₹${similar.price}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      
      // Bottom Bar
      bottomNavigationBar: Obx(() {
        if (controller.productDetail.value == null) return SizedBox.shrink();
        
        return Container(
          padding: EdgeInsets.all(AppSizes.width(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Wishlist Button
              IconButton(
                onPressed: () {
                  wishlistController.isInWishlist(productId)
                      ? wishlistController.removeFromWishlist(productId)
                      : wishlistController.addToWishlist(productId);
                },
                icon: Obx(() => Icon(
                  wishlistController.isInWishlist(productId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: wishlistController.isInWishlist(productId)
                      ? Colors.red
                      : Colors.grey,
                )),
              ),
              
              SizedBox(width: AppSizes.width(16)),
              
              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    cartController.addToCart(productId, controller.quantity.value);
                    Get.snackbar('Success', 'Added to cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.height(12)),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}