import 'api_product_model.dart';

class ProductDetailModel {
  final int productId;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String unit;
  final String weight;
  final String? image;
  final bool isFeatured;
  final bool isRecommended;
  final double rating;
  final int reviewCount;
  final String categoryName;
  final int discountPercentage;
  final List<ApiProductModel> similarProducts;

  ProductDetailModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.unit,
    required this.weight,
    this.image,
    required this.isFeatured,
    required this.isRecommended,
    required this.rating,
    required this.reviewCount,
    required this.categoryName,
    required this.discountPercentage,
    required this.similarProducts,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      originalPrice: double.tryParse(json['original_price']?.toString() ?? '0') ?? 0.0,
      unit: json['unit'] ?? '',
      weight: json['weight']?.toString() ?? '',
      image: json['image'],
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      isRecommended: json['is_recommended'] == true || json['is_recommended'] == 1,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      categoryName: json['category_name'] ?? '',
      discountPercentage: json['discount_percentage'] ?? 0,
      similarProducts: (json['similar_products'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ?? [],
    );
  }
}