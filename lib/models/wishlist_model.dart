class WishlistModel {
  final int wishlistId;
  final int productId;
  final String name;
  final double price;
  final double originalPrice;
  final String? image;
  final String unit;
  final String weight;
  final double rating;
  final bool isFeatured;
  final bool isRecommended;
  final String categoryName;
  final String vendorName;
  final int discountPercentage;
  final DateTime addedAt;

  WishlistModel({
    required this.wishlistId,
    required this.productId,
    required this.name,
    required this.price,
    required this.originalPrice,
    this.image,
    required this.unit,
    required this.weight,
    required this.rating,
    required this.isFeatured,
    required this.isRecommended,
    required this.categoryName,
    required this.vendorName,
    required this.discountPercentage,
    required this.addedAt,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      wishlistId: json['wishlist_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['original_price'] ?? 0).toDouble(),
      image: json['image'],
      unit: json['unit'] ?? '',
      weight: json['weight'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isFeatured: json['is_featured'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      categoryName: json['category_name'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      discountPercentage: json['discount_percentage'] ?? 0,
      addedAt: DateTime.tryParse(json['added_at'] ?? '') ?? DateTime.now(),
    );
  }
}