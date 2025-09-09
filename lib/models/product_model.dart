class ProductModel {
  final int productId;
  final int vendorId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final int stockQuantity;
  final String unit;
  final String weight;
  final String? image;
  final List<String>? images;
  final bool isFeatured;
  final bool isRecommended;
  final double rating;
  final double avgRating;
  final int reviewCount;
  final String categoryName;
  final String vendorName;
  final String vendorOwnerName;
  final double vendorRating;
  final int discountPercentage;
  final DateTime createdAt;

  ProductModel({
    required this.productId,
    required this.vendorId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.stockQuantity,
    required this.unit,
    required this.weight,
    this.image,
    this.images,
    required this.isFeatured,
    required this.isRecommended,
    required this.rating,
    required this.avgRating,
    required this.reviewCount,
    required this.categoryName,
    required this.vendorName,
    required this.vendorOwnerName,
    required this.vendorRating,
    required this.discountPercentage,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['original_price'] ?? 0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
      unit: json['unit'] ?? '',
      weight: json['weight'] ?? '',
      image: json['image'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      isRecommended: json['is_recommended'] == true || json['is_recommended'] == 1,
      rating: (json['rating'] ?? 0).toDouble(),
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      categoryName: json['category_name'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      vendorOwnerName: json['vendor_owner_name'] ?? '',
      vendorRating: (json['vendor_rating'] ?? 0).toDouble(),
      discountPercentage: json['discount_percentage'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'vendor_id': vendorId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'stock_quantity': stockQuantity,
      'unit': unit,
      'weight': weight,
      'image': image,
      'images': images,
      'is_featured': isFeatured,
      'is_recommended': isRecommended,
      'rating': rating,
      'avg_rating': avgRating,
      'review_count': reviewCount,
      'category_name': categoryName,
      'vendor_name': vendorName,
      'vendor_owner_name': vendorOwnerName,
      'vendor_rating': vendorRating,
      'discount_percentage': discountPercentage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}