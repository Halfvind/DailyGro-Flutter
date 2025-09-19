class ApiProductModel {
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
  final String? images;
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
  final String createdAt;

  ApiProductModel({
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

  factory ApiProductModel.fromJson(Map<String, dynamic> json) {
    return ApiProductModel(
      productId: json['product_id'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.00,
      originalPrice: double.tryParse(json['original_price']?.toString() ?? '0') ?? 0.0,
      stockQuantity: json['stock_quantity'] ?? 0,
      unit: json['unit'] ?? '',
      weight: json['weight']?.toString() ?? '',
      image: json['image'],
      images: json['images'] is List ? json['images'].join(',') : json['images'],
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      isRecommended: json['is_recommended'] == true || json['is_recommended'] == 1,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      avgRating: double.tryParse(json['avg_rating']?.toString() ?? '0') ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      categoryName: json['category_name'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      vendorOwnerName: json['vendor_owner_name'] ?? '',
      vendorRating: double.tryParse(json['vendor_rating']?.toString() ?? '0') ?? 0.0,
      discountPercentage: json['discount_percentage'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}